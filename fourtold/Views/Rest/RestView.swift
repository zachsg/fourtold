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
    @State private var showOldActivities = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        RestMinutesToday()
                        
                        RestMinutesPastWeek()
                    } header: {
                        Text("Stats")
                    }
                    
                    RestTodayActivities(showingOptions: $showingOptions)
                    
                    RestOldActivities(showOldActivities: $showOldActivities)
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
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    if !Calendar.current.isDateInToday(lastDate) {
                        lastDate = .now
                        showOldActivities.toggle()
                        showOldActivities = false
                    }
                }
            }
        }
    }
}

#Preview {
    RestView(healthKitController: HealthKitController())
}
