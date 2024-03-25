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
    @State private var sortBy: FTTagSort = .date
    @State private var search = ""
    
    var tagStats: [FTTagStats] {
        var stats: [FTTagStats] = []
        
        let uniqueTagTitles = Set(tags.map { $0.title })
        
        for tagTitle in uniqueTagTitles {
            var count = 0
            var mostRecent: Date = .distantPast
            var title = ""
            var uses: [FTTagSubStats] = []
            
            for t in tags {
                if t.title == tagTitle {
                    if title.isEmpty {
                        title = t.title
                    }
                    
                    let dateAndTimeOfDay = FTTagSubStats(date: t.date, timeOfDay: t.timeOfDay, mood: t.mood)
                    uses.append(dateAndTimeOfDay)
                    
                    count += 1
                    
                    if t.date > mostRecent {
                        mostRecent = t.date
                    }
                }
            }
            
            let stat = FTTagStats(title: title, usedMostRecent: mostRecent, uses: uses, count: count)
            stats.append(stat)
        }
        
        stats.sort { a, b in
            return switch sortBy {
            case .count:
                a.count > b.count
            case .date:
                a.usedMostRecent > b.usedMostRecent
            case .title:
                a.title < b.title
            }
        }
        
        if !search.isEmpty {
            stats = stats.filter { stat in
                stat.title.lowercased().contains(search.lowercased())
            }
        }
        
        return stats
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tagStats) { stat in
                    DisclosureGroup(
                        content: {
                            TagDetails(allUses: stat.uses)
                        },
                        label: {
                            HStack {
                                Image(systemName: "\(stat.count).circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24)
                                
                                HStack {
                                    Text(stat.title)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(stat.usedMostRecent, format: stat.usedMostRecent.dateFormat())
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    )
                    .tint(.tag)
                }
            }
            .navigationTitle("\(tagTitle) Stats")
            .toolbar {
                ToolbarItemGroup {
                    Picker(selection: $sortBy, label: Text("Sort By")) {
                        ForEach(FTTagSort.allCases, id: \.self) {
                            Label($0.rawValue.capitalized, systemImage: systemImage(for: $0))
                        }
                    }
                    .tint(.tag)
                    
                    Button(tagTitle, systemImage: tagSystemImage) {
                        tagSheetIsShowing.toggle()
                    }
                    .tint(.tag)
                }
            }
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .tag)
                    .interactiveDismissDisabled()
            }
        }
        .searchable(text: $search)
    }
    
    private func systemImage(for sort: FTTagSort) -> String {
        return switch sort {
        case .count:
            "number"
        case .date:
            "calendar"
        case .title:
            "textformat.abc"
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
        let tag5 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)
        let tag6 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)
        let tag7 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)
        let tag8 = FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)

        container.mainContext.insert(tag)
        container.mainContext.insert(tag2)
        container.mainContext.insert(tag3)
        container.mainContext.insert(tag4)
        container.mainContext.insert(tag5)
        container.mainContext.insert(tag6)
        container.mainContext.insert(tag7)
        container.mainContext.insert(tag8)

        return TagView()
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
