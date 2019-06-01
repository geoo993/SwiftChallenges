import UIKit

class FlickrPhotosViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var searches = [FlickrSearchResults]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
  }
}

// MARK: - Navigation
extension FlickrPhotosViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let destination = segue.destination as? SearchResultsViewController,
      let indexPath = tableView.indexPathsForSelectedRows?.first {
      destination.searchResults = searches[indexPath.row]
    }
  }
}

// MARK: - UITableViewDataSource
extension FlickrPhotosViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searches.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let searchResult = searches[indexPath.row]
    
    cell.textLabel?.text = searchResult.searchTerm
    cell.detailTextLabel?.text = "(\(searchResult.searchResults.count))"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            searches.remove(at: indexPath.row)
            tableView.deleteRows(at: [ indexPath ], with: .fade)
        }
    }
}

// MARK: - UISearchBarDelegate
extension FlickrPhotosViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    searchBar.isHidden = true
    activityIndicator.startAnimating()
    
    guard let searchText = searchBar.text else {
      return
    }
    
    FlickrAPI.searchFlickrForTerm(searchText) { [weak self] result in
      
      self?.searchBar.isHidden = false
      self?.activityIndicator.stopAnimating()
      
      switch result {
        
      case .failure(let error):
        
        let alert = UIAlertController(title: "Flickr Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self?.present(alert, animated: true, completion: nil)
        
      case .success(let results):
        
        self?.searches.append(results)
        
        if let searches = self?.searches {
          self?.tableView.insertRows(at: [IndexPath(row: searches.count-1, section: 0)], with: .top)
        }
      }
    }
  }
}
