//
//  RestOptionButton.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftUI

struct RestOptionButton: View {
    @Binding var showingOption: Bool
    @Binding var sheetIsShowing: Bool
    
    let title: String
    let icon: String
    
    var body: some View {
        Button {
            sheetIsShowing.toggle()
            showingOption.toggle()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .padding(.trailing, 4)
                    .foregroundStyle(.white)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundStyle(.rest)
            }
            .padding()
        }
    }
}

#Preview {
    RestOptionButton(showingOption: .constant(true), sheetIsShowing: .constant(false), title: "Read", icon: "book")
}
