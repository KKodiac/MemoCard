//
//  CardModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/19.
//

import Foundation

struct CardModel: Identifiable {
    var id = UUID()
    var name: String
    var title: String
    var subtitle: String
    var company: String
    var phone: String
    var email: String
    var address: String
    var imageURL: String?
    
    init(name: String = "Name",
         title: String = "Title",
         subtitle: String = "Subtitle",
         company: String = "Company",
         phone: String = "Phone",
         email: String = "Email",
         address: String = "Address",
         imageURL: String? = nil) {
        self.name = name
        self.title = title
        self.subtitle = subtitle
        self.company = company
        self.phone = phone
        self.email = email
        self.address = address
        self.imageURL = imageURL
    }
    
    init(card: Card) {
        self.name = card.name!
        self.title = card.title!
        self.subtitle = card.subtitle!
        self.company = card.company!
        self.phone = card.phone!
        self.email = card.email!
        self.address = card.address!
        self.imageURL = card.imageURL
    }
    
    var description: String {
        return "\(self.name) \(self.title) \(self.subtitle) \(self.company) \(self.phone) \(self.email) \(self.address) \(String(describing: self.imageURL))"
    }
}


extension CardModel {
    static func mock() -> Self {
        return CardModel(name: "Name",
                         title: "Title",
                         subtitle: "Subtitle",
                         company: "Company",
                         phone: "Phone",
                         email: "Email",
                         address: "Address",
                         imageURL: nil)
    }
}
