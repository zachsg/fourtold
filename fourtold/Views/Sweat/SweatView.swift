//
//  SweatView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/3/24.
//

import SwiftUI

struct SweatView: View {
    @Bindable var healthKitController: HealthKitController
    
    @State private var tagSheetIsShowing = false
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    WeekZone2DetailView(healthKitController: healthKitController, canNav: false)
                        .frame(height: 300)
                }
                
                Section {
                    HomeZone2Cards(healthKitController: healthKitController, zone2TodayPercent: $zone2TodayPercent, zone2WeekPercent: $zone2WeekPercent, canNav: false)
                }
                
                TagsTodayView()
                
                TagsOldView(color: .sweat)
            }
            .listStyle(.grouped)
            .navigationTitle(sweatTitle)
            .toolbar {
                ToolbarItem {
                    Button(tagTitle, systemImage: tagSystemImage) {
                        tagSheetIsShowing.toggle()
                    }
                    .tint(.sweat)
                }
            }
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .sweat)
                    .interactiveDismissDisabled()
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return SweatView(healthKitController: healthKitController)
}
