//
//  ContentView.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Camera()
                .tabItem {
                    Label("Camera", systemImage: "camera.fill")
                }
            Contact()
                .tabItem {
                    Label("Contact", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
