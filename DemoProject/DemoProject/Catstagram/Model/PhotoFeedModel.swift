//
//  PhotoFeedModel.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/13/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class PhotoFeedModel {
    private let numCommentsToShow = 3
    private let fiveHundredPXBaseURL = "https://api.500px.com/v1/"
    private let fiveHundredPXPhotosURI = "photos/search?term=cat&exclude=Nude,People,Fashion&sort=rating&image_size=3&include_store=store_download&include_states=voted"

    private var imageSize: CGSize
    private var photos = [PhotoModel]()
    private var ids = [Int]()
    private var urlString: String
    
    private var currentPage: UInt = 0
    private var totalPages: UInt = 0
    private var totalItems: UInt = 0
    
    private var hasLoaded = false
    private var fetchPageInProgress = false
    private var refreshFeedInProgress = false
    private var task = URLSessionDataTask()
  
    var curr = 0

    init(imageSize: CGSize) {
        self.imageSize = imageSize

        self.urlString = ""
    }
    
    func numberOfItemsInFeed() -> Int {
        return photos.count
    }
    
    func object(at index: Int) -> PhotoModel {
        return photos[index]
    }

    func index(of photoModel: PhotoModel) -> Int {
        return photos.firstIndex(of: photoModel)!
    }

    func clearFeed() {
        photos = [PhotoModel]()
        ids = [Int]()
        
        currentPage = 0
        fetchPageInProgress = false
        refreshFeedInProgress = false
        task.cancel()
        task = URLSessionDataTask()
    }
    
    func requestPage(with resultCount: UInt, completion: @escaping (([PhotoModel]) -> Void)) {
        guard !fetchPageInProgress else { return }
    
        fetchPageInProgress = true
        fetchPage(with: resultCount, replacingData: false, completion: completion)
    }

    func refreshFeed(with resultCount: UInt, completion: @escaping (([PhotoModel]) -> Void)) {
        guard !refreshFeedInProgress else { return }
        
        refreshFeedInProgress = true
        currentPage = 0
        fetchPage(with: resultCount, replacingData:true) { (results) in
            completion(results)
            self.refreshFeedInProgress = false
        }
    }
    
    func randomPhotoModelFromUnsplash() -> PhotoModel {
        curr = (curr + 1)%5
        let sizes = ["800x600", "800x700", "800x800", "800x900", "800x1000"]
        return PhotoModel(photoDictionary: ["url":"https://source.unsplash.com/random/\(sizes[curr])/?cat",
                                            "created_at": "",
                                            "id": 1,
                                            "title": "Ok, this probably isn't a cat",
                                            "name":"Very nice pic",
                                            "comments_count": 1,
                                            "positive_votes_count": 50])
    }
    
    //MARK: Helpers
    private func fetchPage(with resultCount: UInt, replacingData: Bool, completion: @escaping (([PhotoModel]) -> Void)) {
        if hasLoaded {
            guard currentPage != totalPages else {
                completion([])
                return
            }
        }
        
        var newPhotos: [PhotoModel] = []
        var newIDs: [Int] = []
        
        for _ in 0..<resultCount {
            let newPhoto = randomPhotoModelFromUnsplash()
            newPhotos.append(newPhoto)
            newIDs.append(newPhoto.photoID!)
        }
        
        if replacingData {
            self.photos = newPhotos
            self.ids = newIDs
        } else {
            self.photos.append(contentsOf: newPhotos)
            self.ids.append(contentsOf: newIDs)
        }

        completion(newPhotos)
    }
}
