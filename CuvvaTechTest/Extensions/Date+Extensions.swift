//
//  Date+Extensions.swift
//  Date+Extensions
//
//  Created by Mohamed Mosbah on 02/09/2021.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    func isInRange(_ startDate: Date, endDate: Date) -> Bool {
        return (startDate...endDate).contains(self)
    }
}
