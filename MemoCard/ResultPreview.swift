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
    @State private var name: String = "Name"
    @State private var jobTitle: String = "Job Title"
    @State private var jobDetail: String = "Job Detail"
    @State private var phone: String = "Phone Number"
    @State private var email: String = "Email"
    @State private var address: String = "Address"
    
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .fill(.cyan)
                    .opacity(0.3)
                    .shadow(radius: 50, x: 5, y: 5)
                    .frame(maxHeight: 200)
                    .overlay(alignment: .topLeading) {
                        GeometryReader { geometry in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text("\(name)").font(.title)
                                        .dropDestination(for: TextItem.self) { items, location in
                                            name = items.first?.text ?? "Name"
                                            return true
                                        }
                                    Spacer()
                                    Text("\(jobTitle)")
                                        .dropDestination(for: TextItem.self) { items, location in
                                            jobTitle = items.first?.text ?? "Job Title"
                                            return true
                                        }
                                    Text("\(jobDetail)")
                                        .dropDestination(for: TextItem.self) { items, location in
                                            jobDetail = items.first?.text ?? "Job Detail"
                                            return true
                                        }
                                }
                                Spacer()
                                HStack {
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Spacer()
                                        Text("\(phone)")
                                            .dropDestination(for: TextItem.self) { items, location in
                                                phone = items.first?.text ?? "Phone Number"
                                                return true
                                            }
                                        Text("\(email)")
                                            .dropDestination(for: TextItem.self) { items, location in
                                                email = items.first?.text ?? "Email"
                                                return true
                                            }
                                        Text("\(address)")
                                            .dropDestination(for: TextItem.self) { items, location in
                                                address = items.first?.text ?? "Address"
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
                List($results, id: \.self) { result in
                    TextField("Instructions", text: result)
                        .draggable(TextItem(text: result.wrappedValue))
                    
                }
                .onReceive(cameraViewModel.service.publisher, perform: { (output: [String]) in
                    self.results = output
                })
            }
            VStack {
                Spacer()
                Button(action: { print("\(name)") }, label: {
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

struct TextItem: Identifiable, Codable {
    var id: UUID = UUID()
    var text: String
}

extension TextItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: TextItem.self, contentType: .text)
    }
}

struct ResultPreview_Previews: PreviewProvider {
    static var previews: some View {
        ResultPreview(cameraViewModel: CameraViewModel())
    }
}
