//
//  MemoCardApp.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import SwiftUI

@main
struct MemoCardApp: App {
    let service = CoreDataService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, service.persistentContainer.viewContext)
        }
    }
}
