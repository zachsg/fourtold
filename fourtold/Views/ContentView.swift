//
//  ContentView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(HealthKitController.self) private var healthKitController
    
    @State private var tabSelected: FTTabItem = .summary
    
    var body: some View {
        TabView(selection: $tabSelected) {
            HomeView()
                .tabItem {
                    Image(systemName: summarySystemImage)
                    Text(summaryTitle)
                }
                .tag(FTTabItem.summary)
            
            MoveView()
                .tabItem {
                    Image(systemName: moveSystemImage)
                    Text(moveTitle)
                }
                .tag(FTTabItem.move)
            
            SweatView()
                .tabItem {
                    Image(systemName: sweatSystemImage)
                    Text(sweatTitle)
                }
                .tag(FTTabItem.sweat)
            
            RestView()
                .tabItem {
                    Image(systemName: restSystemImage)
                    Text(restTitle)
                }
                .tag(FTTabItem.rest)
            
            TagView()
                .tabItem {
                    Image(systemName: tagCircleSystemImage)
                    Text(tagTitle)
                }
                .tag(FTTabItem.tag)
        }
        .tint(tabColor())
        .onAppear(perform: NotificationController.requestAuthorization)
        .sensoryFeedback(.impact(weight: .light, intensity: 0.8), trigger: tabSelected)
    }
    
    func tabColor() -> Color {
        switch tabSelected {
        case .move:
                .move
        case .sweat:
                .sweat
        case .rest:
                .rest
        case .tag:
                .tag
        case .settings:
                .accentColor
        default:
                .accentColor
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.stepCountToday = 3000
    healthKitController.stepCountWeek = 50000
    healthKitController.zone2Today = 5
    healthKitController.zone2Week = 60
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTMeditate.self,
            FTRead.self,
            FTBreath.self,
            FTTag.self,
            FTTagOption.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return ContentView()
        .modelContainer(sharedModelContainer)
        .environment(healthKitController)
}
