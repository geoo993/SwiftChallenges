import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  
  var flickrPhoto: FlickrPhoto! {
    didSet {
      if flickrPhoto.isFavourite {
        heartButton.tintColor = UIColor(red:1, green:0, blue:0.517, alpha:1)
      } else {
        heartButton.tintColor = UIColor.white
      }
    }
  }
  
  var heartToggleHandler: ((_ isFavourite: Bool) -> Void)?
  override func prepareForReuse() {
    imageView.image = nil
  }
}

// MARK: - IBActions
extension SearchResultsCollectionViewCell {
  
  @IBAction func heartTapped(_ sender: AnyObject) {
    flickrPhoto.isFavourite = !flickrPhoto.isFavourite
    
    heartToggleHandler?(flickrPhoto.isFavourite)
  }
}
