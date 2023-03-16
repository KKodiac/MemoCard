//
//  Contact.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/03/13.
//

import SwiftUI

struct Contact: View {
    @StateObject private var viewModel: Self.ViewModel = .init()
    
    var body: some View {
        NavigationStack {
            verticalCarousel
            contactList
        }
        .onOpenURL { url in
            viewModel.widgetRelatedCard(Int(url.absoluteString)!)
        }
    }
}

extension Contact {
    @ViewBuilder
    var verticalCarousel: some View {
        if viewModel.isCardAvailable {
            VStack(spacing: 8) {
                SnapCarousel()
                    .environmentObject(viewModel.stateModel)
            }
            .onAppear {
                viewModel.updateContacts()
            }
        } else {
            VStack(alignment: .center) {
                Text("Submit a new card!")
            }
            .onAppear {
                viewModel.updateContacts()
            }
        }
        
    }
    
    @ViewBuilder
    var contactList: some View {
        if viewModel.isCardAvailable {
            List {
                Group {
                    Label(viewModel.selectedCard.name, systemImage: "person")
                    Text("Name \(viewModel.selectedCard.name)")
                    Text("Company \(viewModel.selectedCard.company)")
                    Text("Title \(viewModel.selectedCard.title)")
                    Text("Subtitle \(viewModel.selectedCard.subtitle)")
                }
                Group {
                    Text("Email \(viewModel.selectedCard.email)")
                    Text("Phone \(viewModel.selectedCard.phone)")
                    Text("Address \(viewModel.selectedCard.address)")
                }
                
            }.listStyle(.sidebar)
        } else {
            VStack(alignment: .center) {
                Text("There is nothing to show!")
            }
        }
    }
}
struct Contact_Previews: PreviewProvider {
    static var previews: some View {
        Contact()
    }
}
