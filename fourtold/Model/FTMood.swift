//
//  FTMood.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/18/23.
//

import Foundation

enum FTMood: String, Codable, CaseIterable {
    case veryUnpleasant = "very unpleasant",
         unpleasant,
         slightlyUnpleasant = "slightly unpleasant",
         neutral,
         slightlyPleasant = "slightly pleasant",
         pleasant,
         veryPleasant = "very pleasant"
}
