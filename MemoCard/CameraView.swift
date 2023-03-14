//
//  CameraView.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/05.
//

import SwiftUI

struct Camera: View {
    @StateObject private var viewModel: ViewModel = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.top)
            VStack {
                CameraPreview(session: viewModel.service.session)
            }
            Button(action: {
                viewModel.capture()
            }, label: { Text("Capture") })
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
        .sheet(isPresented: $viewModel.isPresented) {
            ResultPreview(viewModel: viewModel)
        }
}
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        Camera()
    }
}
