//
//  ReadingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftData
import SwiftUI

struct ReadDetailView: View {
    @Bindable var read: FTRead
    
    @AppStorage(readGoalKey) var readGoal: Int = 1800
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: readSystemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96)
                    .foregroundColor(.accentColor)
                    .padding(.top, 16)
                
                Text(read.type.rawValue.capitalized)
                    .font(.title)
                    .padding(.top, 4)
                
                HStack(spacing: 0) {
                    Text(read.startDate, format: .dateTime.hour().minute())
                    Text(" on ")
                    Text(read.startDate, format: .dateTime.day().month())
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Text("You read for \(TimeInterval(read.duration).secondsAsTime(units: .full)).")
                    .font(.subheadline)
                    .padding(.bottom, 12)
                
                Divider()
            }
        }
        .navigationTitle("Reading Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTRead.self, configurations: config)
        
        let mood: FTMood = .neutral
        let now: Date = .now
        
        let read = FTRead(startDate: now, timeOfDay: now.timeOfDay(), startMood: mood, endMood: mood, type: .book, genre: .fantasy, duration: 1800, isTimed: true)
        
        return ReadDetailView(read: read)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
