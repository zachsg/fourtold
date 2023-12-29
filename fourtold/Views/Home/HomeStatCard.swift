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
    
    private var inputView: () -> Content
    
    init(headerTitle: String, headerImage: String, date: Date, color: Color, @ViewBuilder inputView: @escaping () -> Content) {
        self.headerTitle = headerTitle
        self.headerImage = headerImage
        self.date = date
        self.color = color
        self.inputView = inputView
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
                        Text("Yesterday")
                    } else {
                        Text(date, format: Calendar.current.isDateInToday(date) ? .dateTime.hour().minute() : .dateTime.day().month())
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
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
    }
}

#Preview {
    HomeStatCard(headerTitle: "Steps today", headerImage: stepsSystemImage, date: .now, color: .move) {
        Text("Hello")
    }
}
