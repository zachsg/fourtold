//
//  FTReadGenre.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/18/23.
//

import Foundation

enum FTReadGenre: String, Codable, CaseIterable {
    case adventure,
         biography,
         fantasy,
         fiction,
         horror,
         health,
         history,
         humor,
         mystery,
         news,
         philosophy,
         poetry,
         psychology,
         religion,
         romance,
         science,
         sciFi = "science fiction",
         other
}
