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
    
    @AppStorage(hasVO2Key) var hasVO2: Bool = true
    
    var body: some View {
        HomeView(healthKitController: healthKitController)
            .onAppear(perform: NotificationController.requestAuthorization)
        
//        TabView(selection: $tabSelected) {
//            HomeView(healthKitController: healthKitController)
//                .tabItem {
//                    Image(systemName: homeSystemImage)
//                    Text(homeTitle)
//                }
//                .tag(FTTabItem.overview)
//            
//            BodyView()
//                .tabItem {
//                    Image(systemName: bodySystemImage)
//                    Text(bodyTitle)
//                }
//                .tag(FTTabItem.body)
//            
//            MindView(healthKitController: healthKitController)
//                .tabItem {
//                    Image(systemName: mindSystemImage)
//                    Text(mindTitle)
//                }
//                .tag(FTTabItem.mind)
//            
//            SettingsView()
//                .tabItem {
//                    Image(systemName: settingsSystemImage)
//                    Text(settingsTitle)
//                }
//                .tag(FTTabItem.settings)
//        }
//        .onAppear(perform: NotificationController.requestAuthorization)
    }
}

#Preview {
    ContentView()
}
