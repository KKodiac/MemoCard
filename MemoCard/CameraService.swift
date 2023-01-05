//
//  Camera.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import SwiftUI
import AVFoundation
import Vision

import os

private let logger = Logger(subsystem: "com.seanhong.KKodiac.MemoCard", category: "CameraService")

public enum CameraError: Error {
    case cameraUnavailable
    case cannotAddInput
    case cannotAddOutput
    case createCaptureInput(Error)
    case deniedAuthorization
    case restrictedAuthorization
    case unknownAuthorization
}

extension CameraError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Camera is unavailable."
        case .cannotAddInput:
            return "Cannot add capture input to session"
        case .cannotAddOutput:
            return "Cannot add video output to session"
        case .createCaptureInput(let error):
            return "Creating capture input for camera: \(error.localizedDescription)"
        case .deniedAuthorization:
            return "Camera access denied"
        case .restrictedAuthorization:
            return "Attempting to access a restricted capture device"
        case .unknownAuthorization:
            return "Unknown authorization status for capture device"
        }
    }
}

public final class CameraService: NSObject, ObservableObject {
    public enum CameraStatus {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    public static let shared = CameraService()
    
    @Published public var error: CameraError?
    @Published public var currentImage: UIImage?
    
    // Pixel size of an average business card.
    // private let photoDimensions = CMVideoDimensions(width: 1050, height: 600)

    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.seanhong.KKodiac.MemoCard.sessionQueue")
    private var currentSessionInput: AVCaptureInput?
    private let currentSessionOutput = AVCaptureVideoDataOutput()
    private let currentSessionPhotoOutput = AVCapturePhotoOutput()
    private var cameraStatus = CameraStatus.unconfigured
    
    private override init() {
        super.init()
        configure()
    }
    
    private func configure() {
        checkPermissions()
        sessionQueue.async {
            self.configureCaptureSession()
            self.start()
        }
    }
    
    private func configurationError(for errorType: CameraError?) {
        DispatchQueue.main.async {
            self.error = errorType
        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.cameraStatus = .unauthorized
                    self.configurationError(for: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            cameraStatus = .unauthorized
            configurationError(for: .restrictedAuthorization)
        case .denied:
            cameraStatus = .unauthorized
            configurationError(for: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            cameraStatus = .unauthorized
            configurationError(for: .unknownAuthorization)
        }
    }
    
    private func configureCaptureSession() {
        guard cameraStatus == .unconfigured else { return }
        guard configureCaptureSessionInput() else { return }
        guard configureCaptureSessionOutput() else { return }
        guard configureCaptureSessionPhotoOutput() else { return }
        cameraStatus = .configured
    }
    
    private func getCameraDevice(_ position: AVCaptureDevice.Position = .back) -> AVCaptureDevice? {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
        return device
    }
    
    private func configureCaptureSessionInput(_ position: AVCaptureDevice.Position = .back) -> Bool {
        guard let camera = getCameraDevice() else {
            configurationError(for: .cameraUnavailable)
            cameraStatus = .failed
            return false
        }
        
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            currentSessionInput = cameraInput
            guard session.canAddInput(cameraInput) else {
                configurationError(for: .cannotAddInput)
                cameraStatus = .failed
                return false
            }
            session.addInput(cameraInput)
        } catch {
            configurationError(for: .createCaptureInput(error))
            cameraStatus = .failed
            return false
        }
        
        return true
    }
    
    private func configureCaptureSessionPhotoOutput() -> Bool {
        guard session.canAddOutput(currentSessionPhotoOutput) else {
            configurationError(for: .cannotAddOutput)
            cameraStatus = .failed
            return false
        }
        
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        session.addOutput(currentSessionPhotoOutput)
        // currentSessionPhotoOutput.maxPhotoDimensions =
        currentSessionPhotoOutput.isHighResolutionCaptureEnabled = true
        currentSessionPhotoOutput.maxPhotoQualityPrioritization = .quality
        let cameraOutput = currentSessionPhotoOutput.connection(with: .video)
        cameraOutput?.videoOrientation = .portrait
        return true
    }
    
    private func configureCaptureSessionOutput() -> Bool {
        guard session.canAddOutput(currentSessionOutput) else {
            configurationError(for: .cannotAddOutput)
            cameraStatus = .failed
            return false
        }
        
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        session.addOutput(currentSessionOutput)
        currentSessionOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        currentSessionOutput.alwaysDiscardsLateVideoFrames = true
        let cameraOutput = currentSessionOutput.connection(with: .video)
        cameraOutput?.videoOrientation = .portrait
        return true
    }
    
    public func setCameraQuality(_ quality: AVCaptureSession.Preset = .high) {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        if session.canSetSessionPreset(quality) {
            session.sessionPreset = quality
        }
    }
    
    public func start() {
        session.startRunning()
    }
    
    public func stop() {
        session.stopRunning()
    }
    
    public func capture() {
        let photoSettings = AVCapturePhotoSettings()
        self.currentSessionPhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        logger.log("[CameraService]: Photo captured.")
    }
    
    
    // MARK: Vision Framework
    var results: [VNRecognizedTextObservation]?
    var requestHandler: VNImageRequestHandler?
    var textRecognitionRequest: VNRecognizeTextRequest!
    
    internal func performTextRecognition(with data: Data, _ recognitionLevel: VNRequestTextRecognitionLevel) {
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else {
                logger.error("[Vision]: Unexpected type of text observation.")
                return
            }
            self.results = results
        }
        textRecognitionRequest.recognitionLevel = recognitionLevel
        textRecognitionRequest.recognitionLanguages = ["ko-KR", "en-US"]
        
        guard let image = UIImage(data: data) else { return }
        requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try requestHandler?.perform([textRecognitionRequest])
        } catch {
            logger.error("[Vision]: Unable to perform request.")
        }
        
        logger.log("[CameraService]: Text recognition completed.")
        self.results?.forEach {
            $0.topCandidates(3).forEach { candidate in
                logger.log("[Vision]: Number of VNRecognized texts: \(candidate.string)")
            }
        }
        
    }
}
