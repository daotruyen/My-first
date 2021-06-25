//
//  selfConfiguring.swift
//  Weather
//
//  Created by Tuyen on 25/06/2021.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: numberTemperature)
}

