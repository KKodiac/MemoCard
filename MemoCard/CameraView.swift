//
//  CameraView.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import SwiftUI

struct Camera: View {
    @StateObject private var viewModel: ViewModel = .init()
    @State private var isPresented = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack {
                CameraPreview(session: viewModel.service.session)
                Button(action: {
                    viewModel.capture()
                    isPresented.toggle()
                }, label: { Text("Capture") })
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $isPresented) {
            ResultPreview(cameraViewModel: viewModel)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        Camera()
    }
}
