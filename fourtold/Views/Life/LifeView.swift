//
//  LifeView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct LifeView: View {
    var body: some View {
        NavigationStack {
            Text(lifeTitle)
                .navigationTitle(lifeTitle)
        }
    }
}

#Preview {
    LifeView()
}
