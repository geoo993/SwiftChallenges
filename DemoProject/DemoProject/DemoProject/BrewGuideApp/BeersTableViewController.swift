
import UIKit
import BreweryDBKit

class BeersTableViewController: UITableViewController {
  
  var apiManager: APIManager!
  var style: Style!
  
  var beers: [Beer] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var beersRequest = GetBeersRequest()
    beersRequest.styleId = style.id
    beersRequest.hasLabels = true
    beersRequest.withBreweries = true
    
    apiManager.send(request: beersRequest) { [weak self] (result) in
      guard let strongSelf = self else { return }
      switch result {
      case .failure(let error):
        print("Failed fetching beers for styleId \(strongSelf.style.id): \(error.localizedDescription)")
      case .success(let response):
        strongSelf.beers = response.data
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowBeer",
      let cell = sender as? UITableViewCell,
      let indexPath = tableView.indexPath(for: cell),
      let beerDetailViewController = segue.destination as? BeerDetailViewController
    {
      let beer = beers[indexPath.row]
      beerDetailViewController.beer = beer
      beerDetailViewController.apiManager = apiManager
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Beer", for: indexPath) as! BeerTableViewCell
    
    let beer = beers[indexPath.row]
    cell.configure(with: beer, apiManager: apiManager)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let beerCell = cell as? BeerTableViewCell else { return }
    beerCell.cancelImageLoading()
  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beer = beers[indexPath.row]
        if let beerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetailViewController") as? BeerDetailViewController {
            beerDetailViewController.beer = beer
            beerDetailViewController.apiManager = apiManager
            self.navigationController?.pushViewController(beerDetailViewController, animated: true)
        }
        
    }
}

