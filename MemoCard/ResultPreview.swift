//
//  ResultPreview.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/20.
//

import SwiftUI

struct ResultPreview: View {
    @ObservedObject var cameraViewModel: CameraViewModel
    @State var results: [String] = []
    
    var body: some View {
        List($results, id: \.self) { result in
            Label (title: {
                TextField("Instructions", text: result)
            }, icon: { Image(systemName: "person") })
        }
        .onReceive(cameraViewModel.service.publisher, perform: { (output: [String]) in
            self.results = output
        })
    }
}
