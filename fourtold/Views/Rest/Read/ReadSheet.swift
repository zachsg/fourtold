//
//  ReadSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftUI

struct ReadSheet: View {
    @AppStorage(readGoalKey) var readGoal: Int = readGoalDefault
    
    @Binding var showingSheet: Bool
    
    @State private var readType: FTReadType = .book
    @State private var genre: FTReadGenre = .fiction
    @State private var startDate: Date = .now
    @State private var isTimed = true
    @State private var mood: FTMood = .neutral
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Reading details") {
                    Picker(selection: $readType, label: Text("What are you reading?")) {
                        ForEach(FTReadType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    
                    Picker(selection: $genre, label: Text("What genre is it?")) {
                        ForEach(FTReadGenre.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                }
                
                Section("Mood") {
                    MoodPicker(mood: $mood, color: .rest) {
                        Text("How're you feeling?")
                    }
                }
                
                Section("Session details") {
                    Toggle(isOn: $isTimed) {
                        Label(
                            title: {
                                Text("Timed session?")
                            },
                            icon: {
                                Image(systemName: isTimed ? readTimedSystemImage : readOpenSystemImage)
                                    .foregroundStyle(.rest)
                            }
                        )
                    }
                    
                    if isTimed {
                        Stepper(value: $readGoal, in: 300...7200, step: 300) {
                            Label(
                                title: {
                                    HStack {
                                        Text("Goal:")
                                        Text(readGoal / 60, format: .number)
                                            .bold()
                                        Text("min")
                                    }
                                }, icon: {
                                    Image(systemName: isTimed ? readTimedSystemImage : readOpenSystemImage)
                                        .foregroundStyle(.rest)
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Read")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                    .foregroundStyle(.rest)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        ReadingView(readType: $readType, genre: $genre, mood: $mood, isTimed: $isTimed, readGoal: $readGoal, startDate: $startDate, showingSheet: $showingSheet)
                    }
                    .foregroundStyle(.rest)
                }
            }
        }
    }
}

#Preview {
    ReadSheet(showingSheet: .constant(true))
}
