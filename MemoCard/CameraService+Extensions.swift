//
//  CameraService+Extensions.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import AVFoundation
import SwiftUI


import os

private let logger = Logger(subsystem: "com.seanhong.KKodiac.MemoCard", category: "CameraServiceDelegate")
extension CameraService: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        self.currentImage = UIImage(data: data)
        self.performTextRecognition(with: data)
        logger.log("[CameraServiceDelegate]: didFinishProcessingPhoto complete.")
    }
}
