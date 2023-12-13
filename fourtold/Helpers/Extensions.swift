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
}
