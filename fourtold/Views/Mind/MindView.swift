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
    
    @State private var path = NavigationPath()
    
    @State private var meditateSheetIsShowing = false
    @State private var breathworkSheetIsShowing = false
    @State private var journalSheetIsShowing = false
    @State private var readSheetIsShowing = false
    
    @State private var showOldActivities = false
    
    var todayActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        
        activities.append(contentsOf: todayMeditates)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var olderActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let olderMeditates = meditates.filter { !isToday(date: $0.startDate) }
        
        activities.append(contentsOf: olderMeditates)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !todayActivities.isEmpty {
                    Section("Today") {
                        ForEach(todayActivities, id: \.id) { activity in
                            if let meditate = activity as? FTMeditate {
                                NavigationLink(value: meditate) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Label {
                                                Text("Meditation")
                                                    .foregroundColor(.accentColor)
                                                Spacer()
                                                Text(meditate.startDate, format: .dateTime.hour().minute())
                                                    .foregroundStyle(.secondary)
                                            } icon: {
                                                Image(systemName: meditateSystemImage)
                                                    .foregroundColor(.accentColor)
                                                    
                                            }
                                        }
                                        .font(.caption)
                                        
                                        HStack {
                                            Label {
                                                HStack {
                                                    Text(meditate.type == .open ? "Open-ended:" : "Timed:")
                                                    Text("\(TimeInterval(meditate.duration).secondsAsTime(units: .short))")
                                                }
                                            } icon: {
                                                Image(systemName: meditate.type == .open ? meditateOpenSystemImage : meditateTimedSystemImage)
                                            }
                                        }
                                        .foregroundStyle(.primary)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    }
                                }
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
                }
                
                if !olderActivities.isEmpty {
                    Section(isExpanded: $showOldActivities) {
                        ForEach(olderActivities, id: \.id) { activity in
                            if let meditate = activity as? FTMeditate {
                                NavigationLink(value: meditate) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Label {
                                                Text("Meditation")
                                                    .foregroundColor(.accentColor)
                                                Spacer()
                                                Text(meditate.startDate, format: .dateTime.day().month())
                                                    .foregroundStyle(.secondary)
                                            } icon: {
                                                Image(systemName: meditateSystemImage)
                                                    .foregroundColor(.accentColor)
                                                
                                            }
                                        }
                                        .font(.caption)
                                        
                                        HStack {
                                            Label {
                                                HStack {
                                                    Text(meditate.type == .open ? "Open-ended:" : "Timed:")
                                                    Text("\(TimeInterval(meditate.duration).secondsAsTime(units: .short))")
                                                }
                                            } icon: {
                                                Image(systemName: meditate.type == .open ? meditateOpenSystemImage : meditateTimedSystemImage)
                                            }
                                        }
                                        .foregroundStyle(.primary)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    }
                                }
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
            .toolbar {
                ToolbarItemGroup {
                    Button(readTitle, systemImage: readSystemImage) {
                        readSheetIsShowing.toggle()
                        // TODO: Add reading
                    }
                    
                    Button(journalTitle, systemImage: journalSystemImage) {
                        journalSheetIsShowing.toggle()
                        // TODO: Add journaling
                    }
                    
                    Button(breathTitle, systemImage: breathSystemImage) {
                        breathworkSheetIsShowing.toggle()
                        // TODO: Add breathwork
                    }
                    
                    Button(meditateTitle, systemImage: meditateSystemImage) {
                        meditateSheetIsShowing.toggle()
                    }
                }
            }
            .sheet(isPresented: $readSheetIsShowing) {
                Text("Read sheet")
            }
            .sheet(isPresented: $journalSheetIsShowing) {
                Text("Journal sheet")
            }
            .sheet(isPresented: $breathworkSheetIsShowing) {
                Text("Breathwork sheet")
            }
            .sheet(isPresented: $meditateSheetIsShowing) {
                MeditationsSheet(healthKitController: healthKitController, showingSheet: $meditateSheetIsShowing)
                    .interactiveDismissDisabled()
            }
        }
        .onAppear {
            let refreshToday = todayActivities
            let refreshOlder = olderActivities
        }
    }
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return MindView(healthKitController: healthKitController)
        .modelContainer(for: FTMeditate.self)
}
