//
//  Four78Section.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/15/23.
//

import SwiftUI

struct Four78Section: View {
    @Binding var rounds: Int
    
    var body: some View {
        Section {
            Stepper(value: $rounds, in: 4...8) {
                HStack(spacing: 0) {
                    Text("How many rounds?")
                    Text(rounds, format: .number)
                        .fontWeight(.bold)
                        .padding(.leading, 4)
                }
            }
        } header: {
            Text("4-7-8 breath")
        } footer: {
            VStack(alignment: .leading) {
                Text("4-7-8 breathing, popularized by Dr. Andrew Weil, calms the mind and body. It can reduce stress and improving sleep.")

                Text("Learn more:")
                    .padding(.top, 4)
                
                Label {
                    Link("Andrew Weil", destination: URL(string: "https://www.drweil.com/videos-features/videos/breathing-exercises-4-7-8-breath/")!)
                        .font(.footnote)
                } icon: {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 4, height: 4)
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 4)
                
                Label {
                    Link("Cleveland Clinic", destination: URL(string: "https://health.clevelandclinic.org/4-7-8-breathing")!)
                        .font(.footnote)
                } icon: {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 4, height: 4)
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 4)
                
                Label {
                    Link("WebMD", destination: URL(string: "https://www.webmd.com/balance/what-to-know-4-7-8-breathing")!)
                        .font(.footnote)
                } icon: {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 4, height: 4)
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 4)
            }
        }
    }
}

#Preview {
    Four78Section(rounds: .constant(4))
}
