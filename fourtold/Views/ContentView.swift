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
    
    @AppStorage(hasCardioKey) var hasCardio: Bool = true
    
    var body: some View {
        TabView(selection: $tabSelected) {
            HomeView(healthKitController: healthKitController)
                .tabItem {
                    Image(systemName: homeSystemImage)
                    Text(homeTitle)
                }
                .tag(FTTabItem.overview)
            
            BodyView()
                .tabItem {
                    Image(systemName: bodySystemImage)
                    Text(bodyTitle)
                }
                .tag(FTTabItem.body)
            
            MindView()
                .tabItem {
                    Image(systemName: mindSystemImage)
                    Text(mindTitle)
                }
                .tag(FTTabItem.mind)
            
            LifeView()
                .tabItem {
                    Image(systemName: lifeSystemImage)
                    Text(lifeTitle)
                }
                .tag(FTTabItem.life)
            
            SettingsView()
                .tabItem {
                    Image(systemName: settingsSystemImage)
                    Text(settingsTitle)
                }
                .tag(FTTabItem.settings)
        }
        .onAppear(perform: NotificationController.requestAuthorization)
    }
}

#Preview {
    ContentView()
}
