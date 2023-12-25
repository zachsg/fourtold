//
//  StatMinutesItem.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/24/23.
//

import SwiftUI

struct StatItem: View {
    var minutes: Int
    var title: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            VStack {
                Text("\(minutes)")
                    .font(.title.weight(.semibold))
                
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    StatItem(minutes: 20, title: "Meditate")
}
