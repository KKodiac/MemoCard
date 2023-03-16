//
//  ContactViewModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/03/13.
//

import SwiftUI
import Combine

extension Contact {
    final class ViewModel: ObservableObject {
        private let service = CoreDataService.shared
        @Published private(set) var stateModel: UIStateModel = UIStateModel()
        @Published private(set) var activeCard: Int = 0
        @Published private(set) var selectedCard: SnapCard = SnapCard()
        @Published var isCardAvailable: Bool = true
        private var cancellables: [AnyCancellable] = []

        init() {
            self.stateModel.$activeCard.sink { completion in
                switch completion {
                case let .failure(error):
                    print("finished with error: ", error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] activeCard in
                self?.someCoolMethodHere(for: activeCard)
            }.store(in: &cancellables)
        }
        
        func updateContacts() {
            self.stateModel.contacts = service.fetchCards()
        }
        
        func widgetRelatedCard(_ index: Int) {
            stateModel.activeCard = index
        }
        
        private func someCoolMethodHere(for activeCard: Int) {
            print("someCoolMethodHere: index received: ", activeCard)
            self.activeCard = activeCard
            if let card = service.fetchCard(activeCard) {
                self.selectedCard = card
            } else {
                self.isCardAvailable.toggle()
            }
        }
    }
}
