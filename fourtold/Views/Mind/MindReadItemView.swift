//
//  MindReadItemView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftData
import SwiftUI

struct MindReadItemView: View {
    @Bindable var read: FTRead
    
    var body: some View {
        NavigationLink(value: read) {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: readSystemImage)
                        Text("Reading")
                    }
                    .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text(read.startDate, format: dateFormat(for: read.startDate))
                        .foregroundStyle(.tertiary)
                }
                .font(.footnote.bold())
                
                VStack(alignment: .leading) {
                    Text("\(read.type.rawValue.capitalized): \(read.genre.rawValue.capitalized)")
                        .font(.headline)
                    
                    Text("Read for \(TimeInterval(read.duration).secondsAsTime(units: .full))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .foregroundStyle(.primary)
                .padding(.top, 4)
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
        let container = try ModelContainer(for: FTRead.self, configurations: config)
        
        let mood: FTMood = .neutral
        let now: Date = .now
        
        let read = FTRead(startDate: now, timeOfDay: now.timeOfDay(), startMood: mood, endMood: mood, type: .book, genre: .fantasy, duration: 600, isTimed: false)
            
        return MindReadItemView(read: read)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
