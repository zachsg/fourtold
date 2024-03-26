//
//  TagDetails.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/5/24.
//

import SwiftData
import SwiftUI

struct TagDetails: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTTag.date, order: .reverse) var tags: [FTTag]

    var title: String
    var allUses: [FTTagSubStats]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allUses) { use in
                    HStack {
                        Image(systemName: use.timeOfDay.systemImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)

                        Text(use.date, format: use.date.dateFormat())
                            .font(.subheadline)
                            .padding(.trailing, 8)

                        Image(systemName: "arrow.triangle.merge")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(90))
                            .frame(width: 12)
                            .foregroundStyle(use.mood.color())
                            .padding(.trailing, 4)

                        HStack(spacing: 0) {
                            Text(use.mood.emoji())
                                .padding(.trailing, 4)
                            Text(use.mood.rawValue.capitalized)
                                .font(.caption)
                                .foregroundStyle(use.mood.color())
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        let tagStat = allUses[index]
                        let tag = tags.first { t in
                            t.id == tagStat.id
                        }

                        if let tag {
                            modelContext.delete(tag)
                        }
                    }
                })
            }
            .navigationTitle("#\(title)")
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTTag.self, configurations: config)
        
        return TagDetails(title: "Sauna", allUses: [
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .unpleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .slightlyPleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .neutral),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .slightlyUnpleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .veryPleasant),
        ])
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
