//
//  Extensions.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/12/23.
//

import Foundation

extension TimeInterval {
    func secondsAsTime(units: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = units
        
        return formatter.string(from: TimeInterval(self)) ?? "n/a"
    }
    
    func secondsAsTimeRoundedToMinutes(units: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = units
        
        let secondsRounded = TimeInterval((self / 60.0).rounded() * 60)
        
        return formatter.string(from: TimeInterval(secondsRounded)) ?? "n/a"
    }
    
    func secondsToMinutesRounded() -> Int {
        Int((self / 60.0).rounded()) * 60
    }
}

extension Date {
    func timeOfDay() -> FTTimeOfDay {
        let hour = Calendar.current.component(.hour, from: self)
        
        return switch hour {
        case 3..<10:
            .morning
        case 10..<15:
            .midday
        case 15..<19:
            .evening
        case 0..<3, 19...24:
            .night
        default:
            .midday
        }
    }
}

extension FTTimeOfDay {
    func systemImage() -> String {
        return switch self {
        case .morning:
            "sunrise.circle"
        case .midday:
            "sun.max.circle"
        case .evening:
            "sunset.circle"
        case .night:
            "moon.circle"
        }
    }
}

extension FTMood {
    func emoji() -> String {
        return switch self {
        case .sad:
            "😓"
        case .anxious:
            "😬"
        case .tired:
            "😴"
        case .neutral:
            "😶"
        case .calm:
            "😌"
        case .energized:
            "😊"
        case .happy:
            "😃"
        }
    }
    
    func differentThan(mood:FTMood) -> Int {
        func intValueOf(mood: FTMood) -> Int {
            switch mood {
            case .sad:
                1
            case .anxious:
                2
            case .tired:
                3
            case .neutral:
                4
            case .calm:
                5
            case .energized:
                6
            case .happy:
                7
            }
        }
        
        let intValueSelf = intValueOf(mood: self)
        let intValueMood = intValueOf(mood: mood)
        
        return intValueSelf - intValueMood
    }
}
