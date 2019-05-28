//
//  PhotoModel.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/12/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class PhotoModel: NSObject {
    var url: URL?
    var photoID: Int?
    var uploadDateString: String?
    var title: String?
    var descriptionText: String?
    var commentsCount: UInt?
    var likesCount: UInt?
    
    var location: LocationModel?
    
    var ownerUserProfile: UserModel?
    weak var owningCell: CatPhotoTableViewCell?
    
    override init() {
        super.init()
    }
    
    init(photoDictionary: [String: Any]) {
        var urlString = ""
        
        urlString = (photoDictionary["url"] as? String)!
        
        url              = URL(string: urlString)
        photoID          = photoDictionary["id"] as? Int
        title            = photoDictionary["title"] as? String
        descriptionText  = photoDictionary["name"] as? String
        commentsCount    = photoDictionary["comments_count"] as? UInt
        likesCount       = photoDictionary["positive_votes_count"] as? UInt
        uploadDateString = "13h"
        
        location = LocationModel(photoDictionary: ["latitude": 33.9224628, "longitude": -117.2552986])
        
        ownerUserProfile = UserModel(withDictionary: ["user": ["user":1, "username": "Robin Carrey"]])
    }
    
    func descriptionAttributedString(withFontSize size: CGFloat) -> NSAttributedString {
        guard let username = ownerUserProfile?.username, let descriptionText = descriptionText else { return NSAttributedString() }
        return NSAttributedString(string: "\(username) \(descriptionText)", fontSize: CGFloat(size), color: UIColor.darkGray, firstWordColor: UIColor.darkBlue())
    }
    
    func uploadDateAttributedString(withFontSize size: Float) -> NSAttributedString {
        return NSAttributedString(string: uploadDateString, fontSize: CGFloat(size), color: UIColor.lightGray, firstWordColor: nil)
    }
    
    func likesAttributedString(withFontSize size: Float) -> NSAttributedString {
        guard let likesCount = likesCount else { return NSAttributedString() }
        return NSAttributedString(string: "\(likesCount) likes", fontSize: CGFloat(size), color: UIColor.darkBlue(), firstWordColor: nil)
    }
    
    func locationAttributedString(withFontSize size: Float) -> NSAttributedString {
        guard let locationString = location?.locationString else { return NSAttributedString() }
        return NSAttributedString(string: "\(locationString)", fontSize: CGFloat(size), color: .darkGray, firstWordColor: nil)
    }
}
