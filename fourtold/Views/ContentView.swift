//
//  ContentView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelected: FTTabItem = .overview
    @State private var healthKitController = HealthKitController()
    
    @AppStorage(hasVO2Key) var hasVO2: Bool = hasVO2Default
    
    var body: some View {
        TabView(selection: $tabSelected) {
            HomeView(healthKitController: healthKitController)
                .tabItem {
                    Image(systemName: homeSystemImage)
                    Text(homeTitle)
                }
                .tag(FTTabItem.overview)
            
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
//                .settings
                .accentColor
        default:
                .accentColor
        }
    }
}

#Preview {
    ContentView()
}
