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
        CGFloat(progress) / CGFloat(100)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(headerTitle)
                Spacer()
            }
            .foregroundStyle(color)
            .font(.footnote.bold())
            
            VStack(alignment: .leading, spacing: 0) {
                inputView()
                    .tint(.secondary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 8))
                .foregroundStyle(color.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .trim(from: 0, to: completed)
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .butt, lineJoin: .round))
                .rotationEffect(.degrees(180))
                .foregroundStyle(color)
        )
        .padding(.horizontal, 2)
        .padding(.bottom, 2)
    }
}

#Preview {
    let hkController = HKController()
    hkController.stepCountToday = 8000
    
    return HomeStatCard(headerTitle: "Steps today", headerImage: stepsSystemImage, date: .now, color: .move, progress: 80) {
        Text(hkController.stepCountToday, format: .number)
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
        
        HStack(spacing: 0) {
            Text("80%")
                .foregroundStyle(.primary)
                .fontWeight(.heavy)
            Text(" of 10k")
                .foregroundStyle(.secondary.opacity(0.7))
                .fontWeight(.bold)
        }
        .font(.caption)
    }
}
