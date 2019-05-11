//
//  Demo.swift
//  DemoProject
//
//  Created by GEORGE QUENTIN on 07/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import Foundation

public class DemoApp
{
    init() {
        
    }
    /*
     func generate(firstName: String?, lastName: String?)
     {
     // red case
     }
     */
    func generate(firstName: String?, lastName: String?) -> String?
    {
        // green case
        return nil
    }
    
    func calculateAreaOfSquare(w: Int, h: Int) -> Double {
        //return 0 // red case
        return Double(w * h) // green case
    }
    
    func calculateAreaOfSquareWithPossitiveValues(w: Int, h: Int) -> Double {
        if w > 0 && h > 0 {
            return Double(w * h)
        }
        
        return 0
    }
}

