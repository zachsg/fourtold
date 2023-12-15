//
//  MeditationDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftData
import SwiftUI

struct MeditationDetailView: View {
    @Bindable var meditate: FTMeditate
    
    @AppStorage(meditateGoalKey) var meditateGoal: Int = 600
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: meditate.type == .open ? meditateOpenSystemImage : meditateTimedSystemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96)
                    .foregroundColor(.accentColor)
                    .padding(.top, 16)
                
                Text(meditate.type == .open ? "Open-ended" : "Timed")
                    .font(.title)
                    .padding(.top, 4)
                
                HStack(spacing: 0) {
                    Text(meditate.startDate, format: .dateTime.hour().minute())
                    Text(" on ")
                    Text(meditate.startDate, format: .dateTime.day().month())
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 12)
                
                Divider()
            }
            
            VStack(alignment: .leading) {
                Text("You meditated for \(TimeInterval(meditate.duration).secondsAsTime(units: .full)).")
                
                if meditate.type == .timed {
                    VStack(alignment: .leading) {
                        Text("...Your goal was \(TimeInterval(meditate.goal ?? meditateGoal).secondsAsTime(units: .full)).")
                            .padding(.top, 12)
                        
                        if meditate.duration >= meditate.goal ?? meditateGoal {
                            Text("Nice work!!")
                                .padding(.top, 12)
                        } else {
                            Text("Not bad. You'll get 'em next time!")
                                .padding(.top, 12)
                        }
                    }
                }
                
            }
            .padding()
            .font(.headline)
        }
        .navigationTitle("Meditation Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FTMeditate.self, configurations: config)
        
        let meditate = FTMeditate(startDate: .now, type: .timed, duration: 320)
        
        return MeditationDetailView(meditate: meditate)
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
