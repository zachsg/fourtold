//
//  WeekZone2DetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct WeekZone2DetailView: View {
    @Environment(HKController.self) private var hkController
    
    var body: some View {
        WeekZone2BarChart()
            .navigationTitle("Time in Zone 2+ HR")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                hkController.getZone2WeekByDay()
            }
    }
}

#Preview {
    let hkController = HKController()
    
    return WeekZone2DetailView()
        .environment(hkController)
}
