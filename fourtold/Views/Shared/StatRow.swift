//
//  StatRow.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/5/24.
//

import SwiftUI

extension StatRow {
    init(headerImage: String, headerTitle: String, date: Date, stat: Double, color: Color, goal: Int? = nil, units: String? = nil, @ViewBuilder destination: @escaping () -> Destination, @ViewBuilder badge: @escaping () -> Badge) {
        self.headerImage = headerImage
        self.headerTitle = headerTitle
        self.date = date
        self.stat = stat
        self.color = color
        self.goal = goal
        self.units = units
        self.destination = destination
        self.badge = badge
    }
    
    init(headerImage: String, headerTitle: String, date: Date, stat: Double, color: Color, goal: Int? = nil, units: String? = nil, @ViewBuilder badge: @escaping () -> Badge) where Destination == EmptyView {
        self.init(headerImage: headerImage, headerTitle: headerTitle, date: date, stat: stat, color: color, goal: goal, units: units, destination: nil, badge: badge)
    }

    init(headerImage: String, headerTitle: String, date: Date, stat: Double, color: Color, goal: Int? = nil, units: String? = nil, @ViewBuilder destination: @escaping () -> Destination) where Badge == EmptyView {
        self.init(headerImage: headerImage, headerTitle: headerTitle, date: date, stat: stat, color: color, goal: goal, units: units, destination: destination, badge: nil)
    }

    init(headerImage: String, headerTitle: String, date: Date, stat: Double, color: Color, goal: Int? = nil, units: String? = nil) where Destination == EmptyView, Badge == EmptyView {
        self.init(headerImage: headerImage, headerTitle: headerTitle, date: date, stat: stat, color: color, goal: goal, units: units, destination: nil, badge: nil)
    }
}

struct StatRow<Destination: View, Badge: View>: View {
    let headerImage: String
    let headerTitle: String
    let date: Date
    let stat: Double
    let color: Color
    let goal: Int?
    let units: String?
    let destination: (() -> Destination)?
    let badge: (() -> Badge)?

    var body: some View {
        if let destination {
            NavigationLink {
                destination()
            } label: {
                content()
            }
        } else {
            content()
        }
    }
    
    func content() -> some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: headerImage)
                    Text(headerTitle)
                }
                .foregroundStyle(color)
                
                Spacer()
                
                Text(date, format: date.dateFormat())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack {
                HStack(alignment: units != nil && goal == nil ? .firstTextBaseline : .center, spacing: 0) {
                    Text(((stat * 10).rounded())/10, format: .number)
                        .font(.title.weight(.semibold))


                    VStack(alignment: .leading) {
                        if let goal {
                            VStack(alignment: .leading) {
                                Text("\(percentComplete(action: stat, goal: goal))")

                                HStack(spacing: 0) {
                                    Text("of \(goal)")

                                    if let units {
                                        Text(units)
                                            .padding(.leading, 2)
                                    }
                                }
                            }
                        } else if let units {
                            Text(units)
                        }
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.leading, 2)
                }
                .padding(.top, 2)

                Spacer()

                if let badge {
                    badge()
                }
            }
        }
    }
    
    private func percentComplete(action: Double, goal: Int) -> String {
        let percent = ((action / Double(goal)) * 100).rounded()
        
        return String(format: "%.0f%%", percent)
    }
}

#Preview {
    let hkController = HKController()
    hkController.cardioFitnessMostRecent = 44.5
    hkController.cardioFitnessAverage = 42.2
    hkController.latestCardioFitness = .now

    return StatRow(headerImage: stepsSystemImage, headerTitle: "Steps today", date: .now, stat: 7000, color: .move, goal: 10000, units: nil) {
        Text("Destination")
    } badge: {
        VO2Badge()
            .environment(hkController)
    }
}
