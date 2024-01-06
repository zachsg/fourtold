//
//  Extensions.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/12/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

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
    
    func dateFormat() -> Date.FormatStyle {
        let calendar = Calendar.current
        
        return if calendar.isDateInToday(self) {
            .dateTime.hour().minute()
        } else if calendar.component(.year, from: self) == calendar.component(.year, from: .now) {
            .dateTime.day().month()
        } else {
            .dateTime.day().month().year()
        }
    }
    
    func weekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekday = dateFormatter.string(from: self)
        
        return weekday
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
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
        case .veryUnpleasant:
            "😭"
        case .unpleasant:
            "😓"
        case .slightlyUnpleasant:
            "🙁"
        case .neutral:
            "😶"
        case .slightlyPleasant:
            "🙂"
        case .pleasant:
            "😊"
        case .veryPleasant:
            "😁"
        }
    }
    
    func color() -> Color {
        return switch self {
        case .veryUnpleasant:
            .red
        case .unpleasant:
            .orange
        case .slightlyUnpleasant:
            .pink
        case .neutral:
            .purple
        case .slightlyPleasant:
            .blue
        case .pleasant:
            .yellow
        case .veryPleasant:
            .green
        }
    }
    
    func differentThan(mood:FTMood) -> Int {
        func intValueOf(mood: FTMood) -> Int {
            switch mood {
            case .veryUnpleasant:
                1
            case .unpleasant:
                2
            case .slightlyUnpleasant:
                3
            case .neutral:
                4
            case .slightlyPleasant:
                5
            case .pleasant:
                6
            case .veryPleasant:
                7
            }
        }
        
        let intValueSelf = intValueOf(mood: self)
        let intValueMood = intValueOf(mood: mood)
        
        return intValueSelf - intValueMood
    }
}

extension Int {
    func monthName(abbreviated: Bool = true) -> String {
        switch self {
        case 1:
            abbreviated ? "Jan" : "January"
        case 2:
            abbreviated ? "Feb" : "February"
        case 3:
            abbreviated ? "Mar" : "March"
        case 4:
            abbreviated ? "Apr" : "April"
        case 5:
            abbreviated ? "May" : "May"
        case 6:
            abbreviated ? "Jun" : "June"
        case 7:
            abbreviated ? "Jul" : "July"
        case 8:
            abbreviated ? "Aug" : "August"
        case 9:
            abbreviated ? "Sep" : "September"
        case 10:
            abbreviated ? "Oct" : "October"
        case 11:
            abbreviated ? "Nov" : "November"
        case 12:
            abbreviated ? "Dec" : "December"
        default:
            "N/A"
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
