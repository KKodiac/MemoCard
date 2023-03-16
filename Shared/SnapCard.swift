//
//  CardModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/19.
//

import Foundation

struct SnapCard: Decodable, Hashable, Identifiable {
    var id: Int16
    var name: String
    var title: String
    var subtitle: String
    var company: String
    var phone: String
    var email: String
    var address: String
    var imageURL: String?
    
    init(id: Int16 = 0,
         name: String = "Name",
         title: String = "Title",
         subtitle: String = "Subtitle",
         company: String = "Company",
         phone: String = "Phone",
         email: String = "Email",
         address: String = "Address",
         imageURL: String? = nil) {
        self.id = id
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
        self.id = card.id
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
        return "\(self)"
    }
}


extension SnapCard {
    static func mock() -> Self {
        return SnapCard(id: 0,
                        name: "Name",
                        title: "Title",
                        subtitle: "Subtitle",
                        company: "Company",
                        phone: "Phone",
                        email: "Email",
                        address: "Address",
                        imageURL: nil)
    }
}
