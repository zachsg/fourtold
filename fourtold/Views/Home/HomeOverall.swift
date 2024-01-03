//
//  HomeOverallWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/2/24.
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
                
                Divider()
                    .foregroundStyle(.thinMaterial)
                
                HStack {
                    VStack(alignment: .trailing) {
                        Text("Steps:")
                            .foregroundStyle(.move)
                        
                        Text("Zone2:")
                            .foregroundStyle(.sweat)
                        
                        Text(" Rest:")
                            .foregroundStyle(.rest)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(progress.steps, format: .percent)
                            .foregroundStyle(.move)
                        
                        Text(progress.zone2, format: .percent)
                            .foregroundStyle(.sweat)
                        
                        Text(progress.rest, format: .percent)
                            .foregroundStyle(.rest)
                    }
                }
                .font(.footnote.bold())
                
                Spacer()
            }
        }
        .padding(72)
        .overlay {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 24))
                .foregroundStyle(.move.opacity(0.3))
                .padding(-2)
                .overlay {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 24))
                        .foregroundStyle(.sweat.opacity(0.3))
                        .padding(24)
                        .overlay {
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 24))
                                .padding(50)
                                .foregroundStyle(.rest.opacity(0.3))
                        }
                        .overlay {
                            Circle()
                                .trim(from: 0, to: progress.rest)
                                .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.degrees(180))
                                .padding(50)
                                .foregroundStyle(.rest)
                        }
                }
                .overlay {
                    Circle()
                        .trim(from: 0, to: progress.zone2)
                        .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(180))
                        .foregroundStyle(.sweat)
                        .padding(24)
                }
        }
        .overlay {
            Circle()
                .trim(from: 0, to: progress.steps)
                .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(180))
                .foregroundStyle(.move)
                .padding(-2)
        }
    }
}

#Preview {
    HomeOverall(title: "Today", progress: (total: 0.7, steps: 0.8, zone2: 0.6, rest: 0.75))
}
