//
//  Alarm.swift
//  Alarm
//
//  Created by micasasucasa on 1/28/19.
//  Copyright © 2019 Jacob Rosevear. All rights reserved.
//

import Foundation

class Alarm: Equatable, Codable {
    var name: String
    var enabled: Bool
    let uuid: String
    var fireDate: Date
    
    
    init(fireDate: Date, name: String, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
   
    
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: fireDate)
    }
}

// MARK: - Equatable
func ==(lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.uuid == rhs.uuid
}
