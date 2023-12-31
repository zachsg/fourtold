//
//  HomeStatCard.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/27/23.
//

import SwiftUI

struct HomeStatCard<Content: View>: View {
    let headerTitle: String
    let headerImage: String
    let date: Date
    let color: Color
    let progress: Double
    
    private var inputView: () -> Content
    
    init(headerTitle: String, headerImage: String, date: Date, color: Color, progress: Double, @ViewBuilder inputView: @escaping () -> Content) {
        self.headerTitle = headerTitle
        self.headerImage = headerImage
        self.date = date
        self.color = color
        self.progress = progress
        self.inputView = inputView
    }
    
    var completed: CGFloat {
        let p = CGFloat(progress) / CGFloat(100)
        
        print("Progress: \(p)")
        
        return p
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: headerImage)
                Text(headerTitle)
                Spacer()
            }
            .foregroundStyle(color)
            .font(.footnote.bold())
            
            if date != .distantPast {
                Group {
                    if Calendar.current.isDateInYesterday(date) {
                        Text("Updated yesterday")
                    } else if Calendar.current.isDateInToday(date) {
                        Text(date, format: .dateTime.hour().minute())
                    } else {
                        HStack(spacing: 0) {
                            Text("Updated ")
                            Text(date, format: .dateTime.day().month())
                        }
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                inputView()
            }
            .padding(.top, 4)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 4))
                .foregroundStyle(color.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .trim(from: 0, to: completed)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .butt, lineJoin: .round))
                .rotationEffect(.degrees(180))
                .foregroundStyle(color)
        )
    }
}

#Preview {
    HomeStatCard(headerTitle: "Steps today", headerImage: stepsSystemImage, date: .now, color: .move, progress: 80) {
        Text("Hello")
    }
}
