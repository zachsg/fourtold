//
//  TagSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftData
import SwiftUI

struct TagSheet: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTTagOption.title) var tags: [FTTagOption]
    
    @Binding var showingSheet: Bool
    var color: Color
    
    @State private var tagOption: FTTagOption = FTTagOption(title: "", type: .other)
    @State private var mood: FTMood = .neutral
    @State private var title = ""
    @State private var type: FTTagType = .other
    
    var body: some View {
        NavigationStack {
            Form {
                if !tags.isEmpty {
                    Section("My tags") {
                        NavigationLink("Use a recent tags") {
                            TagOptionPicker(title: $title, type: $type)
                        }
                    }
                }
                
                Section("Tag details") {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    
                    Picker(selection: $type, label: Text("Type of tag")) {
                        ForEach(FTTagType.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    
                    MoodPicker(mood: $mood, color: color) {
                        Text("How are you feeling?")
                    }
                }
            }
            .navigationTitle("Add Tag")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                    .foregroundStyle(color)
                }
                
                if !title.isEmpty {
                    ToolbarItem {
                        Button("Save") {
                            let date: Date = .now
                            let tag = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: mood, title: title, type: type)
                            
                            modelContext.insert(tag)
                            
                            if !tags.contains(where: { t in
                                t.title.lowercased() == tag.title.lowercased()
                            }) {
                                let tagOption = FTTagOption(title: title, type: type)
                                modelContext.insert(tagOption)
                            }
                            
                            showingSheet.toggle()
                        }
                        .foregroundStyle(color)
                    }
                }
            }
        }
        .tint(color)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTTagOption.self, configurations: config)
        let container2 = try ModelContainer(for: FTTag.self, configurations: config)
        
        let tagOption = FTTagOption(title: "Sauna", type: .activity)
        let tagOption2 = FTTagOption(title: "Cold plunge", type: .activity)
        let tagOption3 = FTTagOption(title: "Vitamin D", type: .supplement)
        
        container.mainContext.insert(tagOption)
        container.mainContext.insert(tagOption2)
        container.mainContext.insert(tagOption3)
        
        return TagSheet(showingSheet: .constant(true), color: .rest)
            .modelContainer(container)
            .modelContainer(container2)
    } catch {
        fatalError(error.localizedDescription)
    }
}
