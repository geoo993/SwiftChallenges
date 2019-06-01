//
//  CommentView.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/16/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class CommentView: UIView {
    static let maxCommentsToShow = 3
    
    var commentFeed: CommentFeedModel?
    var commentLabels = [UILabel]()
    
    class func height(forCommentFeed commentFeedModel: CommentFeedModel, withWidth width: CGFloat) -> CGFloat {
        var height: CGFloat = 0.0
        var rect = CGRect.zero
        var currentString = NSAttributedString()
        
        let boundingSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        if commentFeedModel.numberOfCommentsForPhotoExceeds(number: maxCommentsToShow) {
            currentString = commentFeedModel.viewAllCommentsAttributedString()
            rect = currentString.boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, context: nil)
            height = height + rect.size.height
        }
        
        for i in 0 ..< commentFeedModel.numberOfItemsInFeed() {
            currentString = (commentFeedModel.object(at: i)?.commentAttributedString())!
            rect = currentString.boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, context: nil)
            height += rect.size.height
        }
        
        return height
    }
    
    init() {
//        self.commentFeed = CommentFeedModel(photoID: 0)
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withCommentFeedModel commentFeedModel: CommentFeedModel?) {
//        commentFeed = commentFeedModel
//        self.removeCommentLabels()
        
//        if let commentFeed = commentFeed {
//            createCommentLabels()
//            var labelsIndex:Int = 0
//            var commentLabelString: NSAttributedString?
//            if commentFeed.numberOfCommentsForPhotoExceeds(number: 3) {
//                commentLabelString = commentFeed.viewAllCommentsAttributedString()
//                commentLabels[labelsIndex].attributedText = commentLabelString
//                labelsIndex += 1
//            }
//            
//            for i in 0 ..< commentFeed.numberOfItemsInFeed() {
//                commentLabelString = commentFeed.object(at: i)?.commentAttributedString()
//                commentLabels[i].attributedText = commentLabelString
//                labelsIndex += 1
//            }
//            
//            setNeedsLayout()
//        }
    }
    
    func createCommentLabels() {
        guard let commentFeed = commentFeed else { return }
        let addViewAllCommentsLabel = commentFeed.numberOfCommentsForPhotoExceeds(number: 3)
        let numCommentsInFeed = commentFeed.numberOfItemsInFeed()
        
        let numLabelsToAdd = addViewAllCommentsLabel ? numCommentsInFeed + 1 : numCommentsInFeed
        
        for _ in 0 ..< numLabelsToAdd {
            let label = UILabel()
            label.numberOfLines = 3
            
            commentLabels.append(label)
            self.addSubview(label)
        }
    }
    
    func removeCommentLabels() {
        for commentLabel in commentLabels {
            commentLabel.removeFromSuperview()
        }
        commentLabels.removeAll()
    }
}
