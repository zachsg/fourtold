//
//  TagsOldView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/2/24.
//

import SwiftData
import SwiftUI

struct TagsOldView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTTag.date, order: .reverse) var tags: [FTTag]
    
    let color: Color
    
    @State private var showingOld = false
    
    var oldTags: [FTTag] {
        tags.filter { !Calendar.current.isDateInToday($0.date) }
    }
    
    var body: some View {
        if !oldTags.isEmpty {
            Section(isExpanded: $showingOld) {
                ForEach(oldTags, id: \.id) { tag in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(tag.title.capitalized)
                                .font(.subheadline.bold())
                            Spacer()
                            Text(tag.date, format: dateFormat(for: tag.date))
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                            Image(systemName: tag.timeOfDay.systemImage())
                                .foregroundStyle(.secondary)
                        }
                        Text(tag.type.rawValue.capitalized)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        let tag = tags[index]
                        modelContext.delete(tag)
                    }
                })
            } header: {
                HStack {
                    Text("Older tags")
                    Spacer()
                    Text(oldTags.count, format: .number)
                        .font(.footnote)
                    Button {
                        withAnimation {
                            showingOld.toggle()
                        }
                    } label: {
                        Image(systemName: showingOld ? "chevron.down.circle" : "chevron.forward.circle")
                            .foregroundStyle(color)
                    }
                }
            }
        }
    }
    
    func dateFormat(for date: Date) -> Date.FormatStyle {
        Calendar.current.isDateInToday(date) ? .dateTime.hour().minute() : .dateTime.day().month()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTTag.self, configurations: config)
        
        let date: Date = .distantPast
        let tag = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .neutral, title: "Sauna", type: .activity)
        let tag2 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .unpleasant, title: "Cold Plunge", type: .activity)
        let tag3 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)
        
        container.mainContext.insert(tag)
        container.mainContext.insert(tag2)
        container.mainContext.insert(tag3)
        
        return TagsOldView(color: .move)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
