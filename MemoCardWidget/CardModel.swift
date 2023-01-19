//
//  CardModel.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/19.
//

import Foundation

struct Card {
    let name: String
    let company: String
    let phone: String
    let email: String
    let imageURL: String
}

struct CardMock {
    let card = Card(name: "Sammy", company: "Apple", phone: "010-1234-5678", email: "email.@mail.com", imageURL: "My Image")
}
