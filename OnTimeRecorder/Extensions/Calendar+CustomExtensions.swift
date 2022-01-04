//
//  Calendar+CustomExtensions.swift
//  OnTimeRecorder
//
//  Created by Yuji Taniguchi on 2022/01/04.
//

import Foundation

extension Calendar {
    var rangeOfThisMonth: Range<Date> {
        startOfThisMonth..<endOfThisMonth
    }

    var startOfThisMonth: Date {
        let thisMonthDate = dateComponents([.year, .month], from: Date())
        return date(from: thisMonthDate)!
    }
    var endOfThisMonth: Date {
        date(byAdding: .month, value: 1, to: startOfThisMonth)!
    }
}
