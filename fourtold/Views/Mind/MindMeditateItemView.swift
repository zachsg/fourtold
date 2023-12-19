//
//  MindItemView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftData
import SwiftUI

struct MindMeditateItemView: View {
    @Bindable var meditate: FTMeditate
    
    var body: some View {
        NavigationLink(value: meditate) {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: meditateSystemImage)
                        Text("Meditation")
                    }
                    .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text(meditate.startDate, format: dateFormat(for: meditate.startDate))
                        .foregroundStyle(.tertiary)
                }
                .font(.footnote.bold())
                
                VStack(alignment: .leading) {
                    Text(meditate.type == .open ? "Open-ended session" : "Timed session")
                        .font(.headline)
                    
                    Text("Meditated for \(TimeInterval(meditate.duration).secondsAsTime(units: .full))")
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
        let container = try ModelContainer(for: FTMeditate.self, configurations: config)
        
        let mood: FTMood = .neutral
        let now: Date = .now
        
        let meditate = FTMeditate(startDate: now, timeOfDay: now.timeOfDay(), startMood: mood, endMood: mood, type: .timed, duration: 300)
        
        return MindMeditateItemView(meditate: meditate)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
