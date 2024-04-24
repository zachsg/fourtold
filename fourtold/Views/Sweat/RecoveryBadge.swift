//
//  RecoveryBadge.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/11/24.
//

import SwiftUI

struct RecoveryBadge: View {
    @Environment(HKController.self) private var hkController

    var trend: FTRecoveryTrend {
        let recoveryAverage = hkController.recoveryAverage
        let recoveryCurrent = hkController.recoveryMostRecent

        return recoveryCurrent.recoveryTrend(given: recoveryAverage)
    }

    var badgeParts: Text {
        let recoveryAverage = hkController.recoveryAverage
        let recoveryCurrent = hkController.recoveryMostRecent
        let trend = recoveryCurrent.recoveryTrend(given: recoveryAverage)

        let main = Text(trend.rawValue.capitalized)

        return main
    }

    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                badgeParts
                    .fontWeight(.bold)
                    .foregroundStyle(trend == .improving ? .sweat : trend == .worsening ? .yellow : .accent)
            }

            Image(systemName: progressSystemImage)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(trend == .improving ? .sweat : trend == .worsening ? .yellow : .accent)
                .rotationEffect(.degrees(trend == .improving ? 45 : trend == .worsening ? 135 : 90))
        }
        .foregroundStyle(.secondary)
        .font(.caption)
    }
}

#Preview {
    let hkController = HKController()
    hkController.recoveryMostRecent = 36
    hkController.recoveryAverage = 32
    hkController.latestRecovery = .now

    return RecoveryBadge()
        .environment(hkController)
}
