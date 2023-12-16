//
//  MindView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftData
import SwiftUI

struct MindView: View {
    @Bindable var healthKitController: HealthKitController
        
    @Environment(\.modelContext) var modelContext    
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    
    @State private var path = NavigationPath()
    
    @State private var meditateSheetIsShowing = false
    @State private var breathworkSheetIsShowing = false
    @State private var journalSheetIsShowing = false
    @State private var readSheetIsShowing = false
    @State private var sunSheetIsShowing = false
    @State private var groundSheetIsShowing = false
    
    @State private var showOldActivities = false
    
    var todayActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        
        activities.append(contentsOf: todayMeditates)
        activities.append(contentsOf: todayReads)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var olderActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let olderMeditates = meditates.filter { !isToday(date: $0.startDate) }
        let olderReads = reads.filter { !isToday(date: $0.startDate) }
        
        activities.append(contentsOf: olderMeditates)
        activities.append(contentsOf: olderReads)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !todayActivities.isEmpty {
                    Section("Today") {
                        ForEach(todayActivities, id: \.id) { activity in
                            if let meditate = activity as? FTMeditate {
                                MindMeditateItemView(meditate: meditate)
                            } else if let read = activity as? FTRead {
                                MindReadItemView(read: read)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let activity = todayActivities[index]
                                modelContext.delete(activity)
                            }
                        }
                    }
                } else {
                    HStack {
                        Text("It's a new day. Time to take action!")
                        Image(systemName: "hand.point.up.fill")
                            .foregroundColor(.accentColor)
                            .font(.title3)
                    }
                    .font(.headline)
                }
                
                if !olderActivities.isEmpty {
                    Section(isExpanded: $showOldActivities) {
                        ForEach(olderActivities, id: \.id) { activity in
                            if let meditate = activity as? FTMeditate {
                                MindMeditateItemView(meditate: meditate)
                            } else if let read = activity as? FTRead {
                                MindReadItemView(read: read)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let activity = olderActivities[index]
                                modelContext.delete(activity)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Older")
                            Spacer()
                            Text(olderActivities.count, format: .number)
                                .font(.footnote)
                            Button {
                                withAnimation {
                                    showOldActivities.toggle()
                                }
                            } label: {
                                Image(systemName: showOldActivities ? "chevron.down.circle" : "chevron.forward.circle")
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle(mindTitle)
            .navigationDestination(for: FTMeditate.self) { meditate in
                MeditationDetailView(meditate: meditate)
            }
            .navigationDestination(for: FTRead.self) { read in
                ReadDetailView(read: read)
            }
            .toolbar {
                ToolbarItemGroup {
                    Button(readTitle, systemImage: readSystemImage) {
                        readSheetIsShowing.toggle()
                    }
                    
                    Button(journalTitle, systemImage: journalSystemImage) {
                        journalSheetIsShowing.toggle()
                    }
                    
                    Button(breathTitle, systemImage: breathSystemImage) {
                        breathworkSheetIsShowing.toggle()
                        // TODO: Add breathwork
                    }
                    
                    Button(meditateTitle, systemImage: meditateSystemImage) {
                        meditateSheetIsShowing.toggle()
                    }
                    
                    Button(sunTitle, systemImage: sunSystemImage) {
                        sunSheetIsShowing.toggle()
                    }
                    
                    Button(groundTitle, systemImage: groundSystemImage) {
                        groundSheetIsShowing.toggle()
                    }
                }
            }
            .sheet(isPresented: $readSheetIsShowing) {
                ReadSheet(healthKitController: healthKitController, showingSheet: $readSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $journalSheetIsShowing) {
                JournalSheet()
            }
            .sheet(isPresented: $breathworkSheetIsShowing) {
                BreathSheet(healthKitController: healthKitController, showingSheet: $breathworkSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $meditateSheetIsShowing) {
                MeditationsSheet(healthKitController: healthKitController, showingSheet: $meditateSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $sunSheetIsShowing) {
                Text("Sunning sheet")
            }
            .sheet(isPresented: $groundSheetIsShowing) {
                Text("Grounding sheet")
            }
        }
        .onAppear {
            let _ = todayActivities
            let _ = olderActivities
        }
    }
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return MindView(healthKitController: healthKitController)
        .modelContainer(for: [FTMeditate.self, FTRead.self])
}
