//
//  fourtoldApp.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftData
import SwiftUI

@main
struct fourtoldApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self])
    }
}
