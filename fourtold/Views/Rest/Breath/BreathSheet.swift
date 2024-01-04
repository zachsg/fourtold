//
//  BreathSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/15/23.
//

import SwiftUI

struct BreathSheet: View {
    @Bindable var healthKitController: HealthKitController
    
    @Binding var showingSheet: Bool
    
    @AppStorage(breathTypeKey) var breathType: FTBreathType = breathTypeDefault
    
    @State private var rounds = 4
    @State private var mood: FTMood = .neutral
    
    var body: some View {
        NavigationStack {
            Form {
                Picker(selection: $breathType.animation(), label: Text("Breath type")) {
                    ForEach(FTBreathType.allCases, id: \.self) { type in
                        switch(type) {
                        case .four78:
                            Text("4-7-8 breath")
                        case .box:
                            Text("Box breath")
                        case .wimHof:
                            Text("Wim Hof method")
                        }
                    }
                }
                
                if breathType == .four78 {
                    Four78Section(rounds: $rounds)
                }
                
                MoodPicker(mood: $mood, color: .rest) {
                    Text("How're you feeling?")
                }
            }
            .navigationTitle("Breathe")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                    .foregroundStyle(.rest)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        // TODO: BreathingView
                        if breathType == .four78 {
                            Four78ingView(healthKitController: healthKitController, rounds: $rounds, mood: $mood, showingMainSheet: $showingSheet)
                        }
                    }
                    .foregroundStyle(.rest)
                }
            }
        }
    }
}

#Preview {
    BreathSheet(healthKitController: HealthKitController(), showingSheet: .constant(false))
}
