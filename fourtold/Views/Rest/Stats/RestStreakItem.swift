//
//  ReadStreakItem.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/23/23.
//

import SwiftUI

struct RestStreakItem: View {
    var label: String
    var streak: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("\(streak)")
                    .font(.headline)
                Text(" \(streak == 1 ? "day" : "days")")
                    .font(.caption)
            }
            .padding(6)
            .padding(.horizontal, 2)
            .background(streak == 0 ? .red : .rest)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)))
            
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    RestStreakItem(label: "Meditate", streak: 1)
}
