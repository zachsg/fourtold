//
//  ReadingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftData
import SwiftUI

struct ReadDetailView: View {
    @Bindable var read: FTRead
    
    @FocusState var commentsFieldActive: Bool
    
    @AppStorage(readGoalKey) var readGoal: Int = 1800
    
    @State private var isEditingUrl = false
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: readSystemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96)
                    .foregroundColor(.accentColor)
                    .padding(.top, 16)
                
                Text(read.type.rawValue.capitalized)
                    .font(.headline)
                    .padding(.top, 4)
                
                HStack {
                    Text(read.startDate, format: .dateTime.hour().minute())
                    Text("on")
                    Text(read.startDate, format: .dateTime.day().month())
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Text("You read for \(TimeInterval(read.duration).secondsAsTime(units: .full)).")
                    .font(.subheadline)
                    .padding(.bottom, 4)
                
                Divider()
            }
            
            VStack(alignment: .leading) {
                Text("\(read.type.rawValue.capitalized) title")
                    .font(.headline)
                    .padding(.top, 4)
                TextField("\(read.type.rawValue.capitalized) title (optional)", text: $read.title)
                    .submitLabel(.done)
                
                Text("Link")
                    .font(.headline)
                    .padding(.top, 12)
                
                if read.url.isEmpty || isEditingUrl {
                    TextField("URL/hyperlink for \(read.type.rawValue)", text: $read.url)
                        .submitLabel(.done)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .onSubmit {
                            if read.url.count > 3 {
                                isEditingUrl = false
                            }
                        }
                } else {
                    Link(destination: URL(string: read.url.contains("http") ? read.url : "http://\(read.url)")!) {
                        Label {
                            Text(read.url)
                        } icon: {
                            Button {
                                isEditingUrl = true
                            } label: {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                }
                
                Text("Session notes")
                    .font(.headline)
                    .padding(.top, 12)
                TextField("Add any session notes", text: $read.comment, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .focused($commentsFieldActive)
                    .toolbar {
                        if commentsFieldActive {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button("Done") {
                                    commentsFieldActive = false
                                }
                            }
                        }
                    }
            }
            .padding()
        }
        .navigationTitle("Reading Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            if read.url.isEmpty {
                isEditingUrl = true
            }
        })
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTRead.self, configurations: config)
        
        let read = FTRead(startDate: .now, type: .book, duration: 1800, isTimed: true)
        
        return ReadDetailView(read: read)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
