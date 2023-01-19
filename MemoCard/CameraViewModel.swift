//
//  CameraViewModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import SwiftUI
import Combine
import AVFoundation

import os

private let logger = Logger(subsystem: "com.seanhong.KKodiac.MemoCard", category: "CameraViewModel")

class CameraViewModel: ObservableObject {
    var service: CameraService = CameraService.shared
    private var subscriptions = Set<AnyCancellable>()
    
    func capture() {
        service.capture()
    }
}
