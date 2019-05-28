//
//  UserModel.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/12/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class UserModel {
    //    let dictionaryRepresentation: [String: Any]
    let userID: Int?
    let username: String?
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let city: String?
    let state: String?
    let country: String?
    let about: String?
    let domain: String?
    
    
    let userPicURL: URL?
    let photoCount: Int?
    let galleriesCount: Int?
    let affection: Int?
    let friendsCount: Int?
    let followersCount: Int?
    let following: Bool?
    
    init?(withDictionary dictionary:[String: Any]) {
        guard let userDictionary = dictionary["user"] as? [String: Any] else { return nil }
        
        self.userID = userDictionary["user"] as? Int
        
        if let username = userDictionary["username"] as? String {
            self.username = username
        } else {
            self.username = "Anonymous"
        }
        
        self.firstName = userDictionary["firstname"] as? String
        self.lastName = userDictionary["lastname"] as? String
        self.fullName = userDictionary["fullname"] as? String
        self.city = userDictionary["city"] as? String
        self.state = userDictionary["state"] as? String
        self.country = userDictionary["country"] as? String
        self.about = userDictionary["about"] as? String
        self.domain = userDictionary["domain"] as? String
        self.photoCount = userDictionary["photos_count"] as? Int
        
        self.galleriesCount = userDictionary["galleries_count"] as? Int
        self.affection = userDictionary["affection"] as? Int
        self.friendsCount = userDictionary["friends_count"] as? Int
        self.followersCount = userDictionary["followers_count"] as? Int
        self.following = userDictionary["following"] as? Bool
        //        self.dictionaryRepresentation = userDictionary
        
        if let urlString = userDictionary["userpic_url"] as? String {
            self.userPicURL = URL(string: urlString)
        } else {
            self.userPicURL = nil
        }
    }
    
    func usernameAttributedString(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: username, fontSize: fontSize, color: UIColor.darkBlue(), firstWordColor: nil)
    }
    
    func fullNameAttributedString(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: fullName, fontSize: fontSize, color: UIColor.lightGray, firstWordColor: nil)
    }
    
    func fetchAvatarImage(withCompletion completion: (() -> Void)) {
        
    }
    
    func downloadUserData(withCompletion completion: (() -> Void)) {
        
    }
    
    class func signedInUserFacts() -> [String: Any] {
        return ["name": "Cat Lover",
                "age": 25,
                "locale": "America",
                "favoritecolor": "blue",
                "dad": "bob",
                "mom": "Janelle",
                "who": "Pittsburg",
                "cares": "Pittsburg",
                "this": "Pittsburg",
                "is": "Pittsburg",
                "just": "Pittsburg",
                "test": "Pittsburg",
                "data": "Pittsburg",
                "do": "Pittsburg",
                "you": "Pittsburg",
                "really": "Pittsburg",
                "need": "Pittsburg",
                "me": "Pittsburg",
                "to": "Pittsburg",
                "make": "Pittsburg",
                "it": "Pittsburg",
                "more": [
                    //                    "locale": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    "favoritecolor": "blue",
                    "dad": "bob",
                    "mom": "Janelle",
                    "who": "Pittsburg",
                    "cares": "Pittsburg",
                    "this": "Pittsburg",
                    "is": "Pittsburg",
                    "just": "Pittsburg",
                    "test": "Pittsburg",
                    "data": "Pittsburg",
                    "do": "Pittsburg",
                    "you": "Pittsburg",
            ],
                "realistic": [
                    //                    "locale": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "favoritecolor": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "dad": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    "mom": "Janelle",
                    "who": "Pittsburg",
                    "cares": "Pittsburg",
                    "this": "Pittsburg",
                    "is": "Pittsburg",
                    "just": "Pittsburg",
                    "test": "Pittsburg",
                    "data": "Pittsburg",
                    "do": "Pittsburg",
                    "you": "Pittsburg",
            ],
                "location": [
                    //                    "locale": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "favoritecolor": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "dad": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    "mom": "Janelle",
                    "who": "Pittsburg",
                    "cares": "Pittsburg",
                    "this": "Pittsburg",
                    "is": "Pittsburg",
                    "just": "Pittsburg",
                    "test": "Pittsburg",
                    "data": "Pittsburg",
                    "do": "Pittsburg",
                    "you": "Pittsburg",
            ],
                "funFacts": [
                    //                    "locale": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "favoritecolor": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "dad": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    "mom": "Janelle",
                    "who": "Pittsburg",
                    "cares": "Pittsburg",
                    "this": "Pittsburg",
                    "is": "Pittsburg",
                    "just": "Pittsburg",
                    "test": "Pittsburg",
                    //                    "data": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "do":  UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
                    //                    "you": UIImageJPEGRepresentation(UIImage(named: "profPic")!, 1.0)!,
            ],
                "children": ["bobJunior", "carlaJunior", "cynthia"],
        ]
    }
}
