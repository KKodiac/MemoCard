//
//  CameraView.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject private var cameraViewModel = CameraViewModel()
    @State private var isPresented = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack {
                CameraPreview(session: cameraViewModel.service.session)
                Button(action: {
                    cameraViewModel.capture()
                    isPresented.toggle()
                }, label: { Text("Capture") })
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $isPresented) {
            ResultPreview(cameraViewModel: cameraViewModel)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
