//
//  FTActivity.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import Foundation
import SwiftData

protocol FTActivity: Identifiable, PersistentModel {
    var id: UUID { get }
    var startDate: Date { get set }
}
