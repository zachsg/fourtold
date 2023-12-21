//
//  RestView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct RestView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @Bindable var healthKitController: HealthKitController
        
    @State private var meditateSheetIsShowing = false
    @State private var breathworkSheetIsShowing = false
    @State private var journalSheetIsShowing = false
    @State private var readSheetIsShowing = false
    @State private var sunSheetIsShowing = false
    @State private var groundSheetIsShowing = false
    @State private var lastDate: Date = .now
    @State private var showingOptions = false
    
    var bestMindfulDay: (day: Date, minutes: Int) {
        var bestDay: Date = .now
        var bestMinutes = 0
        
        for (day, minutes) in healthKitController.mindfulMinutesWeekByDay {
            if minutes > bestMinutes {
                bestDay = day
                bestMinutes = minutes
            }
        }
        
        return (bestDay, bestMinutes)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        RestMindfulMinutesToday(healthKitController: healthKitController)
                        
                        RestMindfulMinutesPastWeek(healthKitController: healthKitController)
                    } header: {
                        Text("Stats")
                    } footer: {
                        if bestMindfulDay.minutes > 0 {
                            HStack(spacing: 0) {
                                Text("Your best day was ")
                                Text(bestMindfulDay.day, format: .dateTime.weekday().month().day())
                                Text(" with \(bestMindfulDay.minutes) minutes.")
                            }
                        }
                    }
                    
                    RestTodayActivities(showingOptions: $showingOptions)
                    
                    RestOldActivities()
                }
                
                if showingOptions {
                    Color.black.opacity(0.9)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showingOptions.toggle()
                            }
                        }
                }
                
                VStack(alignment: .trailing) {
                    if showingOptions {
                        RestOptionButton(showingOption: $showingOptions, sheetIsShowing: $readSheetIsShowing, title: readTitle, icon: readSystemImage)
                        
                        RestOptionButton(showingOption: $showingOptions, sheetIsShowing: $journalSheetIsShowing, title: journalTitle, icon: journalSystemImage)
                        
                        RestOptionButton(showingOption: $showingOptions, sheetIsShowing: $breathworkSheetIsShowing, title: breathTitle, icon: breathSystemImage)
                        
                        RestOptionButton(showingOption: $showingOptions, sheetIsShowing: $meditateSheetIsShowing, title: meditateTitle, icon: meditateSystemImage)
                        
                        RestOptionButton(showingOption: $showingOptions, sheetIsShowing: $sunSheetIsShowing, title: sunTitle, icon: sunSystemImage)
                        
                        RestOptionButton(showingOption: $showingOptions, sheetIsShowing: $groundSheetIsShowing, title: groundTitle, icon: groundSystemImage)
                    }
                    
                    Button {
                        withAnimation {
                            showingOptions.toggle()
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundStyle(.rest)
                    }
                    .background(showingOptions ? .black.opacity(0.9) : Color(UIColor.systemBackground))
                    .clipShape(Circle())
                    .rotationEffect(.degrees(showingOptions ? 45 : 0))
                }
                .padding()
            }
            .navigationTitle(restTitle)
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
            .onAppear(perform: {
                if healthKitController.mindfulMinutesWeek == 0 {
                    refresh(hard: true)
                } else {
                    refresh()
                }
            })
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    if !Calendar.current.isDateInToday(lastDate) {
                        lastDate = .now
                    }
                    
                    let today = Calendar.current.isDateInToday(healthKitController.latestSteps)
                    refresh(hard: !today)
                }
            }
        }
    }
    
    func refresh(hard: Bool = false) {
        healthKitController.getMindfulMinutesToday(refresh: hard)
        healthKitController.getMindfulMinutesRecent(refresh: hard)
//        healthKitController.getMindfulMinutesWeekByDay(refresh: hard)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.mindfulMinutesToday = 10
    healthKitController.mindfulMinutesWeek = 60
    
    let today: Date = .now
    for i in 0...6 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.mindfulMinutesWeekByDay[date] = Int.random(in: 0...30)
        }
    }
    
    return RestView(healthKitController: healthKitController)
}
