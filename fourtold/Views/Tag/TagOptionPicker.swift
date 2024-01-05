//
//  TagOptionPicker.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftData
import SwiftUI

struct TagOptionPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTTagOption.title) var tags: [FTTagOption]
    
    @Binding var title: String
    @Binding var type: FTTagType
    
    var body: some View {
        List {
            ForEach(tags, id: \.id) { tag in
                Button {
                    title = tag.title
                    type = tag.type
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text(tag.title.capitalized)
                        Text(tag.type.rawValue.capitalized)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(.primary)
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    let tag = tags[index]
                    modelContext.delete(tag)
                }
            })
        }
        .navigationTitle("My Tags")
        .toolbar {
            EditButton()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTTagOption.self, configurations: config)
        
        let tagOption = FTTagOption(title: "Grounding", type: .other)
        container.mainContext.insert(tagOption)
        
        return TagOptionPicker(title: .constant("Grounding"), type: .constant(.other))
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
