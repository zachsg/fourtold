//
//  HomeOverall.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 4/26/24.
//

import SwiftUI

struct HomeOverall: View {
    let title: String
    let progress: (total: Double, steps: Double, zone2: Double, rest: Double)
    
    var body: some View {
        VStack {
            VStack {
                Spacer()

                VStack {
                    Text(title.uppercased())
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Text(progress.total, format: .percent)
                        .font(.largeTitle.bold())
                    
                    Text("Overall")
                        .font(.caption)
                }
                
                Spacer()
                
                Divider()
                    .foregroundStyle(.thinMaterial)
                    .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Move:")
                            .foregroundStyle(.move)
                        Text("Sweat:")
                            .foregroundStyle(.sweat)
                        Text("Rest:")
                            .foregroundStyle(.rest)
                    }
                    
                    VStack {
                        ProgressView(value: progress.steps, total: 1.0)
                            .tint(.move)
                        ProgressView(value: progress.zone2, total: 1.0)
                            .tint(.sweat)
                        ProgressView(value: progress.rest, total: 1.0)
                            .tint(.rest)
                    }
                    
                    VStack(alignment: .trailing) {
                        Text(progress.steps, format: .percent)
                            .foregroundStyle(.move)
                        Text(progress.zone2, format: .percent)
                            .foregroundStyle(.sweat)
                        Text(progress.rest, format: .percent)
                            .foregroundStyle(.rest)
                    }
                }
                .font(.footnote.bold())
                .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeOverall(title: "Today", progress: (total: 0.7, steps: 0.8, zone2: 0.6, rest: 0.75))
}
