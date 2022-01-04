//
//  TimeInterval+CustomExtensions.swift
//  OnTimeRecorder
//
//  Created by Yuji Taniguchi on 2022/01/04.
//

import Foundation

extension TimeInterval {
    static func convertToHours(fromSeconds: TimeInterval) -> TimeInterval {
        fromSeconds / 3600
    }
}
