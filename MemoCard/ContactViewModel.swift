//
//  ContactViewModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/03/13.
//

import SwiftUI

extension Contact {
    final class ViewModel: ObservableObject {
        private let service = CoreDataService.shared
        
        @Published var contacts: [CardModel] = []
        
        func fetchContacts() {
            contacts = service.fetchCards()
        }
    }
}
