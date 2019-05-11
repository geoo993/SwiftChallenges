//
//  Movie.swift
//  SimpleMVVM
//
//  Created by Abhisek on 06/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation

enum Genre: Int {
    case Animation
    case Action
    case Adventure
    case Comedy
    case History
    case None
}

struct Movie {
    var title = ""
    var movieImageName = ""
    var genre: Genre = .None
    var isFavorite = false
    var director = ""
    var releaseDate = Date()
    var income = "$0.0"
    var rating = 0.0
    
    init(data: [String: Any]) {
        title = data["title"] as! String
        movieImageName = data["movieImageName"] as! String
        genre = data["genre"] as! Genre
        isFavorite = data["isFavorite"] as! Bool
        director = data["director"] as! String
        releaseDate = data["releaseDate"] as! Date
        income = data["income"] as! String
        rating = data["rating"] as! Double
    }
}
