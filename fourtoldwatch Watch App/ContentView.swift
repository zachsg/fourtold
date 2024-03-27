//
//  ContentView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var healthKitController = HealthKitController()

    var body: some View {
        RestView(healthKitController: healthKitController)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}
