//
//  ContentView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var tabSelected: FTTabItem = .summary
    @State private var healthKitController = HealthKitController()
    
    var body: some View {
        TabView(selection: $tabSelected) {
            HomeView(healthKitController: healthKitController)
                .tabItem {
                    Image(systemName: summarySystemImage)
                    Text(summaryTitle)
                }
                .tag(FTTabItem.summary)
            
            MoveView(healthKitController: healthKitController)
                .tabItem {
                    Image(systemName: moveSystemImage)
                    Text(moveTitle)
                }
                .tag(FTTabItem.move)
            
            SweatView(healthKitController: healthKitController)
                .tabItem {
                    Image(systemName: sweatSystemImage)
                    Text(sweatTitle)
                }
                .tag(FTTabItem.sweat)
            
            RestView(healthKitController: healthKitController)
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
    ContentView()
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}
