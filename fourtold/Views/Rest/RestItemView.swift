//
//  RestItemView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/22/23.
//

import SwiftData
import SwiftUI

struct RestItemView: View {
    var activity: any FTActivity
    
    var moodChange: Int {
        activity.endMood.differentThan(mood: activity.startMood)
    }
    
    var activityCategory: (title: String, systemImage:String) {
        if activity is FTMeditate {
            return ("Meditate", meditateSystemImage)
        } else if activity is FTRead {
            return ("Read", readSystemImage)
        } else {
            return ("Unknown", "")
        }
    }
    
    var duration: Int {
        var d = 0
        
        if activity is FTMeditate {
            if let meditate = activity as? FTMeditate {
                d = meditate.duration
            }
        } else if activity is FTRead {
            if let read = activity as? FTRead {
                d = read.duration
            }
        }
        
        return d
    }
    
    var activityTitle: String {
        var title = ""
        
        if activity is FTMeditate {
            title = "Meditated for"
        } else if activity is FTRead {
            if let read = activity as? FTRead {
                if read.type == .other && read.genre == .other {
                    title = "Read for"
                } else if read.type == .other {
                    title = "Read \(read.genre.rawValue) for"
                } else if read.genre == .other {
                    title = "Read \(read.type == .article ? "an" : "a") \(read.type.rawValue) for"
                } else {
                    title = "Read a \(read.genre.rawValue) \(read.type.rawValue) for"
                }
            }
        } else {
            title = "Unkown"
        }
        
        return title
    }
    
    var body: some View {
        DisclosureGroup {
            HStack {
                Image(systemName: progressSystemImage)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(activity.endMood.color())
                    .rotationEffect(.degrees(90 - Double(moodChange * 10)))
                
                VStack(alignment: .leading) {
                    if moodChange > 0 {
                        Text("Your mood improved from:")
                        HStack {
                            Text(activity.startMood.rawValue)
                                .foregroundStyle(activity.startMood.color())
                                .fontWeight(.bold)
                            Image(systemName: arrowSystemImage)
                            Text(activity.endMood.rawValue)
                                .foregroundStyle(activity.endMood.color())
                                .fontWeight(.bold)
                        }
                    } else if moodChange == 0 {
                        Text("Your mood remained:")
                        Text(activity.endMood.rawValue)
                            .foregroundStyle(activity.endMood.color())
                            .fontWeight(.bold)
                    } else {
                        Text("Your mood declined from")
                        HStack {
                            Text(activity.startMood.rawValue)
                                .foregroundStyle(activity.startMood.color())
                                .fontWeight(.bold)
                            Image(systemName: arrowSystemImage)
                            Text(activity.endMood.rawValue)
                                .foregroundStyle(activity.endMood.color())
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: activityCategory.systemImage)
                        Text(activityCategory.title)
                    }
                    .foregroundStyle(.rest)
                    
                    Spacer()
                    
                    Text(activity.startDate, format: dateFormat(for: activity.startDate))
                        .foregroundStyle(.tertiary)
                    
                    Image(systemName: activity.timeOfDay.systemImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        .foregroundStyle(.secondary)
                    
                }
                .font(.footnote.bold())
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(activityTitle) \(TimeInterval(duration).secondsAsTime(units: .full))")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        HStack {
                            Text(activity.startMood.emoji())
                            Image(systemName: arrowSystemImage)
                            Text(activity.endMood.emoji())
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                }
                .padding(.top, 4)
            }
        }
        .tint(activity.endMood.color())
    }
    
    func dateFormat(for date: Date) -> Date.FormatStyle {
        Calendar.current.isDateInToday(date) ? .dateTime.hour().minute() : .dateTime.day().month()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTRead.self, configurations: config)
        
        let read = FTRead(startDate: .now, timeOfDay: .morning, startMood: .neutral, endMood: .pleasant, type: .book, genre: .fiction, duration: 30, isTimed: false)
        
        return RestItemView(activity: read)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
