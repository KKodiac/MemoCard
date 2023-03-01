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

extension Camera {
    final class ViewModel: ObservableObject {
        var service: CameraService = CameraService.shared
        private var subscriptions = Set<AnyCancellable>()
        @Published var results: [String] = []
        @Published var card: CardModel = CardModel()
        
        func capture() {
            service.capture()
        }
    }
}
