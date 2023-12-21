//
//  WeekMindfulMinutesDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftUI

struct WeekRestMinutesDetailView: View {
    var body: some View {
        WeekRestMinutesBarChart()
            .navigationTitle("Rest Minutes")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    WeekRestMinutesDetailView()
}

