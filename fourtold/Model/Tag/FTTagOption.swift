//
//  FTTagOption.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import Foundation
import SwiftData

@Model
class FTTagOption {
    var id = UUID()
    var title: String = ""
    var type: FTTagType = FTTagType.other
    
    init(id: UUID = UUID(), title: String, type: FTTagType) {
        self.id = id
        self.title = title
        self.type = type
    }
}
