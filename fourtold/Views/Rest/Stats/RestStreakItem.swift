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
                    .font(.title3.bold())
                Text(" \(streak == 1 ? "day" : "days")")
                    .font(.footnote)
            }
            .padding(6)
            .padding(.horizontal, 6)
            .foregroundStyle(.white)
            .background(streak < 5 ? .rest : .accent)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    RestStreakItem(label: "Meditate", streak: 2)
}
