//
//  ResultPreview.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/01/20.
//

import SwiftUI
import Combine

struct ResultPreview: View {
    @FocusState private var fieldFocused: Bool
    @ObservedObject var viewModel: Camera.ViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                cardView
                resultList
            }
            VStack {
                Spacer()
                submitButton
                    .padding()
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

extension ResultPreview {
    @ViewBuilder
    private var cardView: some View {
        RoundedRectangle(cornerRadius: 20, style: .circular)
            .fill(Color.columbiaBlue)
            .shadow(radius: 10, x: 5, y: 5)
            .frame(maxHeight: 200)
            .overlay(alignment: .topLeading) {
                GeometryReader { geometry in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("\(viewModel.card.name)").font(.title)
                                .dropDestination(for: TextItem.self) { items, location in
                                    viewModel.card.name = items.first?.text ?? "Name"
                                    return true
                                }
                            Spacer()
                            Text("\(viewModel.card.title)")
                                .dropDestination(for: TextItem.self) { items, location in
                                    viewModel.card.title = items.first?.text ?? "Title"
                                    return true
                                }
                            Text("\(viewModel.card.subtitle)")
                                .dropDestination(for: TextItem.self) { items, location in
                                    viewModel.card.subtitle = items.first?.text ?? "Subtitle"
                                    return true
                                }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Spacer()
                                Text("\(viewModel.card.phone)")
                                    .dropDestination(for: TextItem.self) { items, location in
                                        viewModel.card.phone = items.first?.text ?? "Phone Number"
                                        return true
                                    }
                                Text("\(viewModel.card.email)")
                                    .dropDestination(for: TextItem.self) { items, location in
                                        viewModel.card.email = items.first?.text ?? "Email"
                                        return true
                                    }
                                Text("\(viewModel.card.address)")
                                    .dropDestination(for: TextItem.self) { items, location in
                                        viewModel.card.address = items.first?.text ?? "Address"
                                        return true
                                    }
                            }
                        }
                    }
                    .padding()
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .padding()
    }
    
    @ViewBuilder
    private var resultList: some View {
        List($viewModel.results, id: \.self) { result in
            TextField("Instructions", text: result)
                .focused($fieldFocused)
                .draggable(TextItem(text: result.wrappedValue))
                .disabled(fieldFocused ? false : true)
        }
        .onReceive(viewModel.service.publisher, perform: { (output: [String]) in
            viewModel.results = output
        })
    }
    
    @ViewBuilder
    private var submitButton: some View {
        Button(action: {
            viewModel.submit()
            dismiss()
        }, label: {
            HStack{
                Spacer()
                Text("Submit").padding()
                Spacer()
            }
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
        ResultPreview(viewModel: Camera.ViewModel.init())
    }
}
