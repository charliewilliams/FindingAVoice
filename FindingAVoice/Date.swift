//
//  Date.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

extension Date {
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    func isSameCalendarDay(as other: Date) -> Bool {
        return self.strippingTimeComponents() == other.strippingTimeComponents()
    }

    func strippingTimeComponents() -> Date {

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)

        return calendar.date(from: components)!
    }
}
