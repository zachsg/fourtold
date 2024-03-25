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

    var allUses: [FTTagSubStats]
    
    var body: some View {
        List {
            Text("All uses")
                .font(.subheadline.bold())
                .foregroundStyle(.tag)
                .padding(.bottom, 8)

            ForEach(allUses) { use in
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 6)
                        .foregroundStyle(.tag)

                    Text(use.date, format: use.date.dateFormat())
                        .font(.subheadline)

                    Image(systemName: use.timeOfDay.systemImage())

                    Text(use.mood.rawValue.capitalized)
                        .font(.subheadline.italic())
                        .foregroundStyle(.secondary)
                }
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    let tagStat = allUses[index]
                    let tag = tags.first { t in
                        t.id == tagStat.id
                    }

                    if let tag {
                        print(tag.title)
                        modelContext.delete(tag)
                    }
                }
            })
        }
        .listStyle(.plain)
        .frame(height: listHeight)
    }

    private var listHeight: CGFloat {
        return if allUses.isEmpty {
            0
        } else if allUses.count < 6 {
            CGFloat(allUses.count * 50 + 30)
        } else {
            302
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTTag.self, configurations: config)
        
        return TagDetails(allUses: [
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .pleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .pleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .pleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .pleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .pleasant),
            FTTagSubStats(date: .now, timeOfDay: .evening, mood: .pleasant),
        ])
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
