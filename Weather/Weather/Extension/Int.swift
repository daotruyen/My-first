//
//  Int.swift
//  Weather
//
//  Created by Tuyen on 24/06/2021.
//

import UIKit

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        return mod
    }
}

