//
//  BoxSection.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/9/24.
//

import SwiftUI

struct BoxSection: View {
    @Binding var rounds: Int

    var body: some View {
        Section {
            Stepper(value: $rounds, in: 20...75, step: 5) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("How many rounds?")

                            Text(rounds, format: .number)
                                .fontWeight(.bold)
                                .padding(.leading, 4)
                        }

                        Text("Equivalent to \(rounds * 16 / 60) minutes")
                            .font(.caption)
                    }
                }
            }
        } header: {
            Text("Box breathing")
        } footer: {
            VStack(alignment: .leading) {
                Text("Box breathing is used by U.S. Navy SEALs to relieve stress. It calms and centers the mind.")

                Text("Learn more:")
                    .padding(.top, 4)

                Label {
                    Link("Cleveland Clinic", destination: URL(string: "https://health.clevelandclinic.org/box-breathing-benefits")!)
                        .font(.footnote)
                } icon: {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 4, height: 4)
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 4)

                Label {
                    Link("WebMD", destination: URL(string: "https://www.webmd.com/balance/what-is-box-breathing")!)
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
    BoxSection(rounds: .constant(40))
}
