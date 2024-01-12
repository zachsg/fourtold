//
//  FTTimeFrame.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/22/23.
//

import Foundation

enum FTTimeFrame: String, Codable, CaseIterable {
    case sevenDays = "7D",
         twoWeeks = "2W",
         month = "30D",
         threeMonths = "3M",
         sixMonths = "6M"
    
    func days() -> Double {
        return switch self {
        case .sevenDays:
            7
        case .twoWeeks:
            14
        case .month:
            30
        case .threeMonths:
            90
        case .sixMonths:
            180
        }
    }
    
    func labelName() -> String {
        return switch self {
        case .sevenDays:
            "7 days"
        case .twoWeeks:
            "2 weeks"
        case .month:
            "30 days"
        case .threeMonths:
            "3 months"
        case .sixMonths:
            "6 months"
        }
    }
}
