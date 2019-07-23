
import UIKit
import BreweryDBKit

class StylesTableViewController: UITableViewController {
  
    let apiManager = APIManager(
        baseUrl: URL(string: "https://sandbox-api.brewerydb.com/v2/")!,
        apiKey: "8f50b4ae30354dd336f7ebe8cbd39321"
    )
    
  
  var styles: [Style] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let stylesRequest = GetStylesRequest()
    apiManager.send(request: stylesRequest) { [weak self] (result) in
      switch result {
      case .failure(let error):
        print("Failed to get styles: \(error.localizedDescription)")
      case .success(let response):
        self?.styles = response.data.sorted { $0.name < $1.name }
      }
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowBeers",
      let cell = sender as? UITableViewCell,
      let indexPath = tableView.indexPath(for: cell),
      let beersTableViewController = segue.destination as? BeersTableViewController
    {
      let style = styles[indexPath.row]
      beersTableViewController.style = style
      beersTableViewController.apiManager = apiManager
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return styles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Style", for: indexPath)
    cell.textLabel?.text = styles[indexPath.row].name
    return cell
  }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let style = styles[indexPath.row]
        if let beersTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeersTableViewController") as? BeersTableViewController {
            beersTableViewController.style = style
            beersTableViewController.apiManager = apiManager
            self.navigationController?.pushViewController(beersTableViewController, animated: true)
        }
        
    }
    
}
