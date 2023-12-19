//
//  MoodPicker.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftUI

struct MoodPicker<Content: View>: View {
    @Binding var mood: FTMood
    
    @ViewBuilder var label: Content
    
    var body: some View {
        Picker(selection: $mood, label: label) {
            ForEach(FTMood.allCases, id: \.self) { type in
                Text("\(type.emoji()) \(type.rawValue.capitalized)")
                    .foregroundStyle(type.color())
            }
        }
    }
}

#Preview {
    MoodPicker(mood: .constant(.veryPleasant)) {
        Text("How are you feeling?")
    }
}
