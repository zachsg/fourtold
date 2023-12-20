//
//  RestMeditateItemView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftData
import SwiftUI

struct RestMeditateItemView: View {
    @Bindable var meditate: FTMeditate
    
    var moodChange: Int {
        meditate.endMood.differentThan(mood: meditate.startMood)
    }
    
    var body: some View {
        DisclosureGroup {
            HStack {
                Image(systemName: progressSystemImage)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(meditate.endMood.color())
                    .rotationEffect(.degrees(90 - Double(moodChange * 10)))
                
                VStack(alignment: .leading) {
                    if moodChange > 0 {
                        Text("Your mood improved from:")
                        HStack {
                            Text(meditate.startMood.rawValue)
                                .foregroundStyle(meditate.startMood.color())
                                .fontWeight(.bold)
                            Image(systemName: arrowSystemImage)
                            Text(meditate.endMood.rawValue)
                                .foregroundStyle(meditate.endMood.color())
                                .fontWeight(.bold)
                        }
                    } else if moodChange == 0 {
                        Text("Your mood remained:")
                        Text(meditate.endMood.rawValue)
                            .foregroundStyle(meditate.endMood.color())
                            .fontWeight(.bold)
                    } else {
                        Text("Your mood declined from")
                        HStack {
                            Text(meditate.startMood.rawValue)
                                .foregroundStyle(meditate.startMood.color())
                                .fontWeight(.bold)
                            Image(systemName: arrowSystemImage)
                            Text(meditate.endMood.rawValue)
                                .foregroundStyle(meditate.endMood.color())
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: meditateSystemImage)
                        Text("Meditation")
                    }
                    .foregroundStyle(restColor)
                    
                    Spacer()
                    
                    Text(meditate.startDate, format: dateFormat(for: meditate.startDate))
                        .foregroundStyle(.tertiary)
                }
                .font(.footnote.bold())
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Meditated for \(TimeInterval(meditate.duration).secondsAsTime(units: .full))")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        HStack {
                            Text(meditate.startMood.emoji())
                            Image(systemName: arrowSystemImage)
                            Text(meditate.endMood.emoji())
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                }
                .padding(.top, 4)
            }
        }
        .tint(meditate.endMood.color())
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
        let endMood: FTMood = .veryPleasant
        let now: Date = .now
        
        let meditate = FTMeditate(startDate: now, timeOfDay: now.timeOfDay(), startMood: startMood, endMood: endMood, type: .timed, duration: 300)
        
        return RestMeditateItemView(meditate: meditate)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
