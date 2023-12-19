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
    
    var moodChange: Int {
        meditate.endMood.differentThan(mood: meditate.startMood)
    }
    
    var body: some View {
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
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Meditated for \(TimeInterval(meditate.duration).secondsAsTime(units: .full))")
                        .font(.headline)
                    
                    HStack {
                        Text(meditate.startMood.emoji())
                        Image(systemName: arrowSystemImage)
                        Text(meditate.endMood.emoji())
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: progressSystemImage)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(moodChange > 0 ? .green : moodChange < 0 ? .red : .secondary)
                    .rotationEffect(.degrees(90 - Double(moodChange * 10)))
            }
            .padding(.top, 4)
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
        
        let startMood: FTMood = .neutral
        let endMood: FTMood = .calm
        let now: Date = .now
        
        let meditate = FTMeditate(startDate: now, timeOfDay: now.timeOfDay(), startMood: startMood, endMood: endMood, type: .timed, duration: 300)
        
        return MindMeditateItemView(meditate: meditate)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
