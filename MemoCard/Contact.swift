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
            List($viewModel.contacts, editActions: .delete) { contact in
                Text(contact.name.wrappedValue)
            }
        }
        .onAppear {
            viewModel.fetchContacts()
        }
    }
}

struct Contact_Previews: PreviewProvider {
    static var previews: some View {
        Contact()
    }
}
