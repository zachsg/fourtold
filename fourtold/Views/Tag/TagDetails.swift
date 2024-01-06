//
//  TagDetails.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/5/24.
//

import SwiftUI

struct TagDetails: View {
    var allUses: [FTTagSubStats]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("All uses")
                    .font(.subheadline.bold())
                    .foregroundStyle(.tag)
                    .padding(.bottom, 8)
                
                ForEach(allUses) { use in
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 6)
                            .foregroundStyle(.tag)
                        
                        Text(use.date, format: use.date.dateFormat())
                            .font(.subheadline)
                        
                        Image(systemName: use.timeOfDay.systemImage())
                        
                        Text(use.mood.rawValue.capitalized)
                            .font(.subheadline.italic())
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.leading, 14)
        }
    }
}

#Preview {
    TagDetails(allUses: [FTTagSubStats(date: .now, timeOfDay: .evening, mood: .pleasant)])
}
