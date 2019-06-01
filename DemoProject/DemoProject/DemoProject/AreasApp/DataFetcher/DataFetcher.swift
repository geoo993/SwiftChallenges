//
//  PlaceDataFetcher.swift
//  DemoTests
//
//  Created by Abhisek on 6/9/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation

protocol AreaDataFetcherProtocol {
    func fetchPlaces(completion: ([Area]?,_ errorMessage: String?)->())
}

class AreaDataFetcher: AreaDataFetcherProtocol {
    
    func fetchPlaces(completion: ([Area]?,_ errorMessage: String?)->()) {
        guard let path = Bundle.main.path(forResource: "PlacesList", ofType: "json") else {
            completion(nil, "There is a problem in fetching places for you.")
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            guard let jsonResult = json as? [String: Any] else {
                completion(nil, "There is a problem in fetching places for you.")
                return
            }
            guard let results = jsonResult["results"] as? [[String: Any]] else { return }
            completion(self.placesListFrom(results: results), nil)
            
        } catch {
            completion(nil, "There is a problem in fetching places for you.")
        }
    }
    
    private func placesListFrom(results: [[String: Any]]) -> [Area] {
        var places = [Area]()
        for place in results {
            places.append(Area(attributes: place))
        }
        return places
    }
    
}
