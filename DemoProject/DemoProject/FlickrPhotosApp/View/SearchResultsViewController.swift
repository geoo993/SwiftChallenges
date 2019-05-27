import UIKit

class SearchResultsViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var searchResults: FlickrSearchResults?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let resultsCount = searchResults!.searchResults.count
    
    title = "\(searchResults!.searchTerm) (\(resultsCount))"
  }
}

// MARK: - UICollectionViewDataSource
extension SearchResultsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchResults!.searchResults.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! SearchResultsCollectionViewCell
    
    if let flickrPhoto = searchResults?.searchResults[indexPath.item] {
      cell.flickrPhoto = flickrPhoto
      
      cell.heartToggleHandler = { [weak self] isStarred in
        self?.collectionView.reloadItems(at: [ indexPath ])
      }
      
      ImageCache.shared.loadThumbnail(for: flickrPhoto) { result in
        
        switch result {
          
        case .success(let image):

          if cell.flickrPhoto == flickrPhoto {
            if flickrPhoto.isFavourite {
                cell.imageView.image = image
            } else {
                if let cachedImage = ImageCache.shared.image(forKey: "\(flickrPhoto.id)-filtered") {
                    cell.imageView.image = cachedImage
                }
                else {
                    DispatchQueue.global().async {
                        if let filteredImage = image.applyTonalFilter() {
                            ImageCache.shared.set(filteredImage, forKey: "\(flickrPhoto.id)-filtered")
                            
                            DispatchQueue.main.async {
                                cell.imageView.image = filteredImage
                            }
                        }
                    }
                }
            }
        }
          
        case .failure(let error):
          print("Error: \(error)")
        }
      }
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // 3 images across
    let width = view.bounds.width / 3
    
    // each image has a ratio of 4:3
    let height = (width / 4) * 3
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
