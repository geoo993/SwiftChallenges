
import UIKit
import BreweryDBKit

class BeerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var labelImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var breweryLabel: UILabel!
  
  private var iconImageTask: URLSessionDataTask?
  
  func configure(with beer: Beer, apiManager: APIManager) {
    
    nameLabel.text = beer.name
    breweryLabel.text = beer.breweryDisplayString
    
    if let iconImageUrl = beer.labels?.iconUrl {
      iconImageTask = apiManager.loadImage(at: iconImageUrl) { [weak self] (result) in
        switch result {
        case .failure(let error):
          print("Error loading Beer label: \(error.localizedDescription)")
        case .success(let image):
          self?.labelImageView.image = image
        }
      }
    }
  }
  
  func cancelImageLoading() {
    iconImageTask?.cancel()
  }
  
}
