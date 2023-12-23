//
//  WeekMindfulMinutesDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftUI

struct WeekRestMinutesDetailView: View {
    @State private var timeFrame: FTTimeFrame = .sevenDays
    
    var body: some View {
        VStack {
            Picker(selection: $timeFrame.animation(), label: Text("Time Frame")) {
                ForEach(FTTimeFrame.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .padding([.top, .leading, .trailing])
            .pickerStyle(.segmented)
            
            WeekRestMinutesBarChart(timeFrame: $timeFrame)
                .navigationTitle("Rest Minutes")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    WeekRestMinutesDetailView()
}
