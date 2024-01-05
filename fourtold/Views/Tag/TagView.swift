//
//  TagView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/4/24.
//

import SwiftData
import SwiftUI

struct TagView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTTag.date, order: .reverse) var tags: [FTTag]
    
    @State private var tagSheetIsShowing = false
    
    var tagStats: [FTTagStats] {
        var stats: [FTTagStats] = []
        
        var uniqueTags: [String] = []
        for tag in tags {
            if !uniqueTags.contains(tag.title) {
                uniqueTags.append(tag.title)
            }
        }
        
        var count = 0
        var mostRecent: Date = .distantPast
        var title = ""
        for tagTitle in uniqueTags {
            for t in tags {
                if t.title == tagTitle {
                    if title.isEmpty {
                        title = t.title
                    }
                    
                    count += 1
                    
                    if t.date > mostRecent {
                        mostRecent = t.date
                    }
                }
            }
            
            let stat = FTTagStats(title: title, usedMostRecent: mostRecent, count: count)
            stats.append(stat)
            
            count = 0
            mostRecent = .distantPast
            title = ""
        }
        
        stats.sort { a, b in
            a.usedMostRecent > b.usedMostRecent
        }
        
        return stats
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tagStats) { stat in
                    HStack {
                        Image(systemName: "\(stat.count).circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                        
                        HStack {
                            Text(stat.title)
                                .font(.headline)
                            Spacer()
                            
                            Text(stat.usedMostRecent, format: dateFormat(for: stat.usedMostRecent))
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("\(tagTitle) Stats")
            .toolbar {
                ToolbarItem {
                    Button(tagTitle, systemImage: tagSystemImage) {
                        tagSheetIsShowing.toggle()
                    }
                }
            }
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .tag)
                    .interactiveDismissDisabled()
            }
        }
    }
    
    private func dateFormat(for date: Date) -> Date.FormatStyle {
        let calendar = Calendar.current
        
        return if calendar.isDateInToday(date) {
            .dateTime.hour().minute()
        } else if calendar.component(.year, from: date) == calendar.component(.year, from: .now) {
            .dateTime.day().month()
        } else {
            .dateTime.day().month().year()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTTag.self, configurations: config)
        
        let date: Date = .now
        let tag = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .neutral, title: "Sauna", type: .activity)
        let tag2 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .unpleasant, title: "Cold Plunge", type: .activity)
        let tag3 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)
        let tag4 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)
        
        container.mainContext.insert(tag)
        container.mainContext.insert(tag2)
        container.mainContext.insert(tag3)
        container.mainContext.insert(tag4)
        
        return TagView()
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
