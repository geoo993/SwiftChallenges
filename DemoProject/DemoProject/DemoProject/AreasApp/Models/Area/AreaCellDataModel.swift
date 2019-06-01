//
//  PlaceCellDataModel.swift
//  DemoTests
//
//  Created by Abhisek on 6/10/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation

struct AreaCellDataModel: Equatable {
    var name: String
    var address: String
    var rating: String
    var openStatusText: String
    
    init(area: Area) {
        name = area.name ?? ""
        address = area.address ?? ""
        rating = area.rating?.description ?? "0.0"
        guard let isOpen = area.openStatus else {
            openStatusText = "Sorry we are closed."
            return
        }
        openStatusText = isOpen ? "We are open. Hop in now!!" : "Sorry we are closed."
    }
}
