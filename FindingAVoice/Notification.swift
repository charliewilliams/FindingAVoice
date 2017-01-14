//
//  Notification.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    enum _Type: String {
        case dailySessionTimeExceeded
        case questionAllowedTimeExceeded
    }
    
    init(_ type: _Type) {
        self = NSNotification.Name(type.rawValue)
    }
}
