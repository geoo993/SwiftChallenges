//
//  DataGenerator.swift
//  SimpleMVVM
//
//  Created by Abhisek on 06/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation

class DataGenerator {
    static var movies: [Movie] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return [
            Movie(data: ["title": "Justice League",         "movieImageName": "justiceleague",  "genre": Genre.Action,
                         "isFavorite": false, "director": "Zack Synder" ,
                         "releaseDate": dateFormatter.date(from: "2017-11-17")!,"income": "$657.9 billion" ,"rating": 7.8 ]),
            Movie(data: ["title": "The Emoji Movie",        "movieImageName": "emohiemovie",  "genre": Genre.Animation,   "isFavorite": false, "director": "Tony Leondis" ,
                         "releaseDate": dateFormatter.date(from: "2017-08-04")!,"income": "$217.7 million" ,"rating": 3.2 ]),
            Movie(data: ["title": "Logan",                  "movieImageName": "logan",  "genre": Genre.Action,   "isFavorite": false, "director": "James Mangold" ,
                         "releaseDate": dateFormatter.date(from: "2017-03-01")!,"income": "$619 million" ,"rating": 8.1 ]),
            Movie(data: ["title": "Wonder Woman",           "movieImageName": "wonderwoman",  "genre": Genre.Adventure,   "isFavorite": false, "director": "Patty Jenkins" ,
                         "releaseDate": dateFormatter.date(from: "2017-06-01")!,"income": "$821.7 million" ,"rating": 7.5 ]),
            Movie(data: ["title": "Zootopia",               "movieImageName": "zootopia",  "genre": Genre.Animation,   "isFavorite": false, "director": "Byron Howard" ,
                         "releaseDate": dateFormatter.date(from: "2016-03-25")!,"income": "$1.023 billion" ,"rating": 8.0 ]),
            Movie(data: ["title": "The Baby Boss",          "movieImageName": "bossbaby",  "genre": Genre.Animation,   "isFavorite": false, "director": "Tom McGrath" ,
                         "releaseDate": dateFormatter.date(from: "2017-04-01")!,"income": "$527.9 million" ,"rating": 6.3 ]),
            Movie(data: ["title": "Despicable Me 3",        "movieImageName": "despicableme",  "genre": Genre.Animation,   "isFavorite": false, "director": "Kyle Balda" ,
                         "releaseDate": dateFormatter.date(from: "2017-06-30")!,"income": "$1.034 billion" ,"rating": 6.3 ]),
            Movie(data: ["title": "Spiderman: Homecoming",  "movieImageName": "spiderman",  "genre": Genre.Action,   "isFavorite": false, "director": "Jon Watts" ,
                         "releaseDate": dateFormatter.date(from: "2017-07-05")!,"income": "$880.1 million" ,"rating": 7.5 ]),
            Movie(data: ["title": "Dunkirk",                "movieImageName": "dunkirk",  "genre": Genre.History,   "isFavorite": false, "director": "Christopher Nolan" ,
                         "releaseDate": dateFormatter.date(from: "2017-07-21")!,"income": "$525.57 million" ,"rating": 7.9 ])
        ]
    }
}
