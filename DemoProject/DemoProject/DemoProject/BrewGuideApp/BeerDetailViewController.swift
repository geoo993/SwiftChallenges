import UIKit
import BreweryDBKit

class BeerDetailViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var labelImageView: UIImageView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var breweryLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var abvValueLabel: UILabel!
  @IBOutlet weak var ibuValueLabel: UILabel!
  
  var beer: Beer!
  var apiManager: APIManager!
  
  private var labelImageTask: URLSessionDataTask?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure(with: beer, apiManager: apiManager)
  }
  
  private func configure(with beer: Beer, apiManager: APIManager) {
    nameLabel.text = beer.name
    breweryLabel.text = beer.breweryDisplayString
    descriptionLabel.text = beer.description
    
    if let abv = beer.abv {
      abvValueLabel.text = abv + "%"
    } else {
      abvValueLabel.text = "--"
    }
    
    if let ibu = beer.ibu {
      ibuValueLabel.text = ibu
    } else {
      ibuValueLabel.text = "--"
    }
    
    if let largeLabelUrl = beer.labels?.largeUrl {
      labelImageTask = apiManager.loadImage(at: largeLabelUrl) { [weak self] (result) in
        switch result {
        case .failure(let error):
          print("Large Beer label image load failed: \(error.localizedDescription)")
        case .success(let image):
          self?.labelImageView?.image = image
        }
      }
    }
  }
  
  deinit {
    labelImageTask?.cancel()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let convertedRect = descriptionLabel.convert(descriptionLabel.frame, to: view)
    scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: convertedRect.maxY)
  }
  
}
