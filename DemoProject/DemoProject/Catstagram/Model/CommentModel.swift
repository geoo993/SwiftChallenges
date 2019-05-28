//
//  CommentModel.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/12/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class CommentModel {
    let dictionaryRepresentation: [String: Any]
    
    let commentID: UInt?
    let commenterID: UInt?
    let commenterUsername: String?
    let commenterAvatarURL: String?
    let body: String?
    let uploadDateString: String?
    
    init(withDictionary dictionary: [String: Any]) {
        self.dictionaryRepresentation = dictionary

        self.commentID = dictionary["id"] as? UInt
        self.commenterID = dictionary["user_id"] as? UInt
        self.body = dictionary["body"] as? String

        if let userDictionary = dictionary["user"] as? [String: Any] {
            self.commenterUsername = userDictionary["username"] as? String
            self.commenterAvatarURL = dictionary["userpic_url"] as? String
        } else {
            self.commenterUsername = nil
            self.commenterAvatarURL = nil
        }
        
        if let rawDate = dictionary["created_at"] as? String {
            self.uploadDateString = NSString.elapsedTime(sinceDate: rawDate) as String
        } else {
            self.uploadDateString = nil
        }
    }
    func commentAttributedString() -> NSAttributedString {
        return NSAttributedString(string: "\(String(describing: commenterUsername?.lowercased())) \(String(describing: body))", fontSize: 14, color: UIColor.darkGray, firstWordColor: UIColor.darkBlue())
    }
    
    func uploadDateAttributedString(with fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: uploadDateString, fontSize: fontSize, color: UIColor.lightGray, firstWordColor: nil)
    }
}
