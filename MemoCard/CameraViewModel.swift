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
        var persistence: CoreDataService = CoreDataService.shared
        private var subscriptions = Set<AnyCancellable>()
        
        @Published var results: [String] = []
        @Published var card: SnapCard = SnapCard()
        @Published var isPresented: Bool = false
        
        func capture() {
            service.capture()
            isPresented.toggle()
        }
        
        func submit() {
            card.id = Int16(persistence.fetchCards().count)
            persistence.insertData(card)
            logger.log("\(self.persistence.fetchCards())")
            card = SnapCard()
        }
    }
}
