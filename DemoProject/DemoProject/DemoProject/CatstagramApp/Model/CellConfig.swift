//
//  CellConfig.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 4/10/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class CellDataPoint {}

class CellConfig {
    unowned var zombie: CellDataPoint
    
    init() {
        let someObject = CellDataPoint()
        zombie = someObject
    }
    
    func saveConfig() {
        print(zombie)
    }
}

