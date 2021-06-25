//
//  Kelvin.swift
//  Weather
//
//  Created by Tuyen on 23/06/2021.
//

import UIKit

extension Float {
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    func kelvin()-> Float{
        let constant:Float = 273.15
        let kelValue = self
        let value = kelValue - constant
        return value.truncate(places: 1)
    }
    
}
