//
//  ReadSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftUI

struct ReadSheet: View {
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(readGoalKey) var readGoal: Int = 1800
    
    @Binding var showingSheet: Bool
    
    @State private var readType: FTReadType = .book
    @State private var startDate: Date = .now
    @State private var isTimed = true
    @State private var title = ""
    @State private var url = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Picker(selection: $readType, label: Text("What are you reading?")) {
                    ForEach(FTReadType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                
                Toggle(isOn: $isTimed) {
                    Label("Timed session?", systemImage: isTimed ? readTimedSystemImage : readOpenSystemImage)
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
                            }
                        )
                    }
                }
                
                TextField("\(readType.rawValue.capitalized) title (optional)", text: $title)
                    .submitLabel(.done)
                
                TextField("URL/hyperlink for \(readType.rawValue) (optional)", text: $url)
                    .submitLabel(.done)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .textContentType(.URL)
                    .keyboardType(.URL)
            }
            .navigationTitle("Read")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        ReadingView(healthKitController: healthKitController, readType: $readType, isTimed: $isTimed, readGoal: $readGoal, startDate: $startDate, title: $title, url: $url, showingSheet: $showingSheet)
                    }
                }
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return ReadSheet(healthKitController: healthKitController, showingSheet: .constant(true))
}

