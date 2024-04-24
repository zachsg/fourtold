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
            var id = UUID()
            var count = 0
            var mostRecent: Date = .distantPast
            var title = ""
            var uses: [FTTagSubStats] = []
            
            for t in tags {
                id = t.id

                if t.title == tagTitle {
                    if title.isEmpty {
                        title = t.title
                    }
                    
                    let dateAndTimeOfDay = FTTagSubStats(id: id, date: t.date, timeOfDay: t.timeOfDay, mood: t.mood)
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
                    NavigationLink {
                        TagDetails(title: stat.title, allUses: stat.uses)
                    } label: {
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
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTTag.self,
            FTTagOption.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            for tag in FTTagData.all {
                container.mainContext.insert(tag)
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return TagView()
        .modelContainer(sharedModelContainer)
}
