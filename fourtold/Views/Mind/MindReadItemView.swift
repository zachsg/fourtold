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
    
    var moodChange: Int {
        read.endMood.differentThan(mood: read.startMood)
    }
    
    var readingTimeFormatted: String {
        TimeInterval(read.duration).secondsAsTime(units: .full)
    }
    
    var readingTitle: String {
        var title = ""
        
        if read.type == .other && read.genre == .other {
            title = "Read for"
        } else if read.type == .other {
            let genre = read.genre == .sciFi ? "science fiction" : read.genre.rawValue
            title = "Read \(genre) for"
        } else if read.genre == .other {
            title = "Read \(read.type == .article ? "an" : "a") \(read.type.rawValue) for"
        } else {
            let genre = read.genre == .sciFi ? "science fiction" : read.genre.rawValue
            title = "Read a \(genre) \(read.type.rawValue) for"
        }
        
        return title
    }
    
    var body: some View {
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
            
            HStack {
                VStack(alignment: .leading) {
                    if read.type == .other {
                        Text("\(readingTitle) \(readingTimeFormatted)")
                            .font(.headline)
                    } else {
                        Text("\(readingTitle) \(readingTimeFormatted)")
                            .font(.headline)
                    }
                    
                    HStack {
                        Text(read.startMood.emoji())
                        Image(systemName: arrowSystemImage)
                        Text(read.endMood.emoji())
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
        let container = try ModelContainer(for: FTRead.self, configurations: config)
        
        let startMood: FTMood = .neutral
        let endMood: FTMood = .happy
        
        let now: Date = .now
        
        let read = FTRead(startDate: now, timeOfDay: now.timeOfDay(), startMood: startMood, endMood: endMood, type: .book, genre: .fantasy, duration: 600, isTimed: false)
            
        return MindReadItemView(read: read)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
