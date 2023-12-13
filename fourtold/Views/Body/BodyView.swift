//
//  BodyView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct BodyView: View {
    var body: some View {
        NavigationStack {
            Text(bodyTitle)
                .navigationTitle(bodyTitle)
        }
    }
}

#Preview {
    BodyView()
}
