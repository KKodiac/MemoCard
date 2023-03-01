//
//  CardModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/19.
//

import Foundation

struct CardModel {
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
}


extension CardModel {
    static func mock() -> Self {
        return CardModel()
    }
}
