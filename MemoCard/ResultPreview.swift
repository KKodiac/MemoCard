//
//  ResultPreview.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/20.
//

import SwiftUI

struct ResultPreview: View {
    @ObservedObject var cameraViewModel: Camera.ViewModel
    @State private var results: [String] = []
    var body: some View {
        ZStack {
            VStack {
                cardView()
                resultList()
            }
            VStack {
                Spacer()
                Button(action: { print("\(cameraViewModel.card.name)") }, label: {
                    HStack{
                        Spacer()
                        Text("Submit").padding()
                        Spacer()
                    }
                })
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

extension ResultPreview {
    private func cardView() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .circular)
            .fill(.cyan)
            .opacity(0.3)
            .shadow(radius: 50, x: 5, y: 5)
            .frame(maxHeight: 200)
            .overlay(alignment: .topLeading) {
                GeometryReader { geometry in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("\(cameraViewModel.card.name)").font(.title)
                                .dropDestination(for: TextItem.self) { items, location in
                                    cameraViewModel.card.name = items.first?.text ?? "Name"
                                    return true
                                }
                            Spacer()
                            Text("\(cameraViewModel.card.title)")
                                .dropDestination(for: TextItem.self) { items, location in
                                    cameraViewModel.card.title = items.first?.text ?? "Title"
                                    return true
                                }
                            Text("\(cameraViewModel.card.subtitle)")
                                .dropDestination(for: TextItem.self) { items, location in
                                    cameraViewModel.card.subtitle = items.first?.text ?? "Subtitle"
                                    return true
                                }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Spacer()
                                Text("\(cameraViewModel.card.phone)")
                                    .dropDestination(for: TextItem.self) { items, location in
                                        cameraViewModel.card.phone = items.first?.text ?? "Phone Number"
                                        return true
                                    }
                                Text("\(cameraViewModel.card.email)")
                                    .dropDestination(for: TextItem.self) { items, location in
                                        cameraViewModel.card.email = items.first?.text ?? "Email"
                                        return true
                                    }
                                Text("\(cameraViewModel.card.address)")
                                    .dropDestination(for: TextItem.self) { items, location in
                                        cameraViewModel.card.address = items.first?.text ?? "Address"
                                        return true
                                    }
                            }
                        }
                    }
                    .padding()
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }.padding()
    }
    
    private func resultList() -> some View {
        List($results, id: \.self) { result in
            TextField("Instructions", text: result)
                .draggable(TextItem(text: result.wrappedValue))
        }
        .onReceive(cameraViewModel.service.publisher, perform: { (output: [String]) in
            self.results = output
        })
    }
}


// MARK: Transferable
extension ResultPreview {
    struct TextItem: Identifiable, Codable {
        var id: UUID = UUID()
        var text: String
    }
}

extension ResultPreview.TextItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: ResultPreview.TextItem.self, contentType: .text)
    }
}

struct ResultPreview_Previews: PreviewProvider {
    static var previews: some View {
        ResultPreview(cameraViewModel: Camera.ViewModel.init())
    }
}
