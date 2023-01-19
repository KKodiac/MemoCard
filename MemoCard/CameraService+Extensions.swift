//
//  CameraService+Extensions.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import AVFoundation
import os

private let logger = Logger(subsystem: "com.seanhong.KKodiac.MemoCard", category: "CameraServiceDelegate")

extension CameraService: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let ocrService = OCRService()
        guard let data = photo.fileDataRepresentation() else { return }
        logger.log("[CameraServiceDelegate]: didFinishProcessingPhoto complete.")
        let results = ocrService.performTextRecognition(with: data, as: .accurate)
        self.publisher.send(results)
    }
}
