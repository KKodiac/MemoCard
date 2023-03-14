//
//  CameraPreview.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import AVFoundation
import SwiftUI
import UIKit

import os

private let logger = Logger(subsystem: "com.seanhong.KKodiac.MemoCard", category: "CameraPreview")

struct CameraPreview: UIViewRepresentable {    
    class PreviewView: UIView {
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            guard let layer = layer as? AVCaptureVideoPreviewLayer else {
                fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
            }
            return layer
        }
        
        var session: AVCaptureSession? {
            get {
                return videoPreviewLayer.session
            }
            set {
                videoPreviewLayer.session = newValue
            }
        }
        
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    
    let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.backgroundColor = .black
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {  }
}
