//
//  FTVO2Category.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/6/24.
//

import Foundation

let vO2Lookup: [FTGender: [FTVO2AgeBracket]] = [
    .male: [
        FTVO2AgeBracket(ageRange: 18...25, categories: [
            FTVO2Category(vO2Range: 61...100, status: .excellent),
            FTVO2Category(vO2Range: 52...60, status: .good),
            FTVO2Category(vO2Range: 47...51, status: .aboveAverage),
            FTVO2Category(vO2Range: 42...46, status: .average),
            FTVO2Category(vO2Range: 37...41, status: .belowAverage),
            FTVO2Category(vO2Range: 30...36, status: .poor),
            FTVO2Category(vO2Range: 0...29, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 26...35, categories: [
            FTVO2Category(vO2Range: 57...100, status: .excellent),
            FTVO2Category(vO2Range: 49...56, status: .good),
            FTVO2Category(vO2Range: 43...48, status: .aboveAverage),
            FTVO2Category(vO2Range: 40...42, status: .average),
            FTVO2Category(vO2Range: 35...39, status: .belowAverage),
            FTVO2Category(vO2Range: 30...34, status: .poor),
            FTVO2Category(vO2Range: 0...29, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 36...45, categories: [
            FTVO2Category(vO2Range: 52...100, status: .excellent),
            FTVO2Category(vO2Range: 43...51, status: .good),
            FTVO2Category(vO2Range: 39...42, status: .aboveAverage),
            FTVO2Category(vO2Range: 35...38, status: .average),
            FTVO2Category(vO2Range: 31...34, status: .belowAverage),
            FTVO2Category(vO2Range: 26...30, status: .poor),
            FTVO2Category(vO2Range: 0...25, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 46...55, categories: [
            FTVO2Category(vO2Range: 46...100, status: .excellent),
            FTVO2Category(vO2Range: 39...45, status: .good),
            FTVO2Category(vO2Range: 36...38, status: .aboveAverage),
            FTVO2Category(vO2Range: 32...35, status: .average),
            FTVO2Category(vO2Range: 29...31, status: .belowAverage),
            FTVO2Category(vO2Range: 25...28, status: .poor),
            FTVO2Category(vO2Range: 0...24, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 56...65, categories: [
            FTVO2Category(vO2Range: 42...100, status: .excellent),
            FTVO2Category(vO2Range: 36...41, status: .good),
            FTVO2Category(vO2Range: 32...35, status: .aboveAverage),
            FTVO2Category(vO2Range: 30...31, status: .average),
            FTVO2Category(vO2Range: 26...29, status: .belowAverage),
            FTVO2Category(vO2Range: 22...25, status: .poor),
            FTVO2Category(vO2Range: 0...21, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 66...120, categories: [
            FTVO2Category(vO2Range: 38...100, status: .excellent),
            FTVO2Category(vO2Range: 33...37, status: .good),
            FTVO2Category(vO2Range: 29...32, status: .aboveAverage),
            FTVO2Category(vO2Range: 26...28, status: .average),
            FTVO2Category(vO2Range: 22...25, status: .belowAverage),
            FTVO2Category(vO2Range: 20...21, status: .poor),
            FTVO2Category(vO2Range: 0...19, status: .veryPoor)
        ])
    ],
    .female: [
        FTVO2AgeBracket(ageRange: 18...25, categories: [
            FTVO2Category(vO2Range: 57...100, status: .excellent),
            FTVO2Category(vO2Range: 47...56, status: .good),
            FTVO2Category(vO2Range: 42...46, status: .aboveAverage),
            FTVO2Category(vO2Range: 38...41, status: .average),
            FTVO2Category(vO2Range: 33...37, status: .belowAverage),
            FTVO2Category(vO2Range: 28...32, status: .poor),
            FTVO2Category(vO2Range: 0...27, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 26...35, categories: [
            FTVO2Category(vO2Range: 53...100, status: .excellent),
            FTVO2Category(vO2Range: 45...52, status: .good),
            FTVO2Category(vO2Range: 39...44, status: .aboveAverage),
            FTVO2Category(vO2Range: 35...38, status: .average),
            FTVO2Category(vO2Range: 31...34, status: .belowAverage),
            FTVO2Category(vO2Range: 26...30, status: .poor),
            FTVO2Category(vO2Range: 0...25, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 36...45, categories: [
            FTVO2Category(vO2Range: 46...100, status: .excellent),
            FTVO2Category(vO2Range: 38...45, status: .good),
            FTVO2Category(vO2Range: 34...37, status: .aboveAverage),
            FTVO2Category(vO2Range: 31...33, status: .average),
            FTVO2Category(vO2Range: 27...30, status: .belowAverage),
            FTVO2Category(vO2Range: 22...26, status: .poor),
            FTVO2Category(vO2Range: 0...21, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 46...55, categories: [
            FTVO2Category(vO2Range: 41...100, status: .excellent),
            FTVO2Category(vO2Range: 34...40, status: .good),
            FTVO2Category(vO2Range: 31...33, status: .aboveAverage),
            FTVO2Category(vO2Range: 28...30, status: .average),
            FTVO2Category(vO2Range: 25...27, status: .belowAverage),
            FTVO2Category(vO2Range: 20...24, status: .poor),
            FTVO2Category(vO2Range: 0...19, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 56...65, categories: [
            FTVO2Category(vO2Range: 38...100, status: .excellent),
            FTVO2Category(vO2Range: 32...37, status: .good),
            FTVO2Category(vO2Range: 28...31, status: .aboveAverage),
            FTVO2Category(vO2Range: 25...27, status: .average),
            FTVO2Category(vO2Range: 22...24, status: .belowAverage),
            FTVO2Category(vO2Range: 18...21, status: .poor),
            FTVO2Category(vO2Range: 0...17, status: .veryPoor)
        ]),
        FTVO2AgeBracket(ageRange: 66...120, categories: [
            FTVO2Category(vO2Range: 33...100, status: .excellent),
            FTVO2Category(vO2Range: 28...32, status: .good),
            FTVO2Category(vO2Range: 25...27, status: .aboveAverage),
            FTVO2Category(vO2Range: 22...24, status: .average),
            FTVO2Category(vO2Range: 19...21, status: .belowAverage),
            FTVO2Category(vO2Range: 17...18, status: .poor),
            FTVO2Category(vO2Range: 0...16, status: .veryPoor)
        ])
    ]
]

struct FTVO2AgeBracket {
    let ageRange: ClosedRange<Int>
    let categories: [FTVO2Category]
}

struct FTVO2Category {
    let vO2Range: ClosedRange<Double>
    let status: FTVO2Status
}

enum FTVO2Status: String, Codable, CaseIterable {
    case veryPoor = "very poor",
         poor,
         belowAverage = "below average",
         average,
         aboveAverage = "above average",
         good,
         excellent,
         unknown
}

enum FTVO2Trend: String, Codable, CaseIterable {
    case stable, improving, declining
}
