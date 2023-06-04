import UIKit

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The strategy pattern is Behavioral Patterns defines a family of interchangeable objects that can be set or switched at runtime. It is a Behavioral Pattern because the strategy pattern is about one object using another to do something.

// This pattern has three parts:

// - The object using a strategy. This is most often a view controller when the pattern is used in iOS app development, but it can technically be any kind of object that needs interchangeable behavior.
// - The strategy protocol defines methods that every strategy must implement.
// - The strategies are objects that conform to the strategy protocol.


// MARK: - When should you use it?
// Use the strategy pattern when you have two or more different behaviors that are interchangeable.
// This pattern is similar to the delegation pattern: both patterns rely on a protocol instead of concrete objects for increased flexibility. Consequently, any object that implements the strategy protocol can be used as a strategy at runtime.
// Unlike delegation, the strategy pattern uses a family of objects.
// Delegates are often fixed at runtime. For example, the dataSource and delegate for a UITableView can be set from Interface Builder, and it’s rare for these to change during runtime.
// Strategies, however, are intended to be easily interchangeable at runtime.

// MARK: - Custom Strategy
// For the code example, consider an app that uses several “movie rating services” such as Rotten Tomatoes®, IMDb and Metacritic.
// Instead of writing code for each of these services directly within a view controller, and likely having complex if-else statements therein, you can use the strategy pattern to simplify things by creating a protocol that defines a common API for every service.

// First, lets create a strategy protocol.
protocol MovieRatingStrategy {
  // 1 - we will use ratingServiceName to display which service provided the rating. For example, this would return “Rotten Tomatoes.”
  var ratingServiceName: String { get }
  
  // 2 - we will use fetchRatingForMovieTitle(_:success:) to fetch movie ratings asynchronously. In a real app, you’d also likely have a failure closure too, as networking calls don’t always succeed.
  func fetchRating(for movieTitle: String,
    success: (_ rating: String, _ review: String) -> ())
}

// - Strategy one
final class RottenTomatoesClient: MovieRatingStrategy {
    let ratingServiceName = "Rotten Tomatoes"
    
    func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> ()
    ) {
        
        // In a real service, you’d make a network request...
        // Here, we just provide dummy values...
        let rating = "95%"
        let review = "It rocked!"
        success(rating, review)
    }
}

// - Strategy two
final class IMDbClient: MovieRatingStrategy {
    let ratingServiceName = "IMDb"
    
    func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> ()
    ) {
        
        let rating = "3 / 10"
        let review = """
      It was terrible! The audience was throwing rotten
      tomatoes!
      """
        success(rating, review)
    }
}

// - Startegy three
final class MetacriticClient: MovieRatingStrategy {
    let ratingServiceName = "Metacritic"
    
    func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> ()
    ) {
        
        let rating = "6 / 10"
        let review =
        """
        Mind blowing!
        The best we've seen in a long time.
        """
        success(rating, review)
    }
}

// Since all three of these clients conform to MovieRatingStrategy, consuming objects don’t need to know about either directly. Instead, they can depend on the protocol alone.

// For example, add the following code at the end of the file:
final class MovieRatingViewController: UIViewController {
    // 2 - Notice how the view controller doesn’t know about the concrete implementations of MovieRatingStrategy. The determination of which MovieRatingStrategy to use can be deferred until runtime, and this could even be selected by the user if your app allowed that.
    private let movieRatingClient: MovieRatingStrategy
    private (set)var ratingServiceName: String!
    private (set)var rating: String!
    private (set)var review: String!
    
    // 1 - Whenever this view controller is instantiated within the app (however that happens), you’d need to set the movieRatingClient
    init(movieRatingClient: MovieRatingStrategy) {
        self.movieRatingClient = movieRatingClient
        super.init(nibName: nil, bundle: nil)
        ratingServiceName = movieRatingClient.ratingServiceName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func search(movie: String) {
        movieRatingClient.fetchRating(for: movie) { (rating, review) in
            self.rating = rating
            self.review = review
        }
    }
}

example(of: "Strategy") {
    let vc = MovieRatingViewController(movieRatingClient: MetacriticClient())
    print(vc.ratingServiceName)
    vc.search(movie: "Alien")
    print(vc.rating)
    print(vc.review)
}

// MARK: - What should you be careful about?
// Be careful about overusing this pattern.
// In particular, if a behavior won’t ever change, it’s okay to put this directly within the consuming view controller or object context.
// The trick to this pattern is knowing when to pull out behaviors, and it’s okay to do this lazily as you determine where it’s needed.


// MARK: - Here are its key points:
// - The strategy pattern defines a family of interchangeable objects that can be set or switched at runtime.
// - This pattern has three parts: an object using a strategy, a strategy protocol, and a family of strategy objects.
// - The strategy pattern is similar to the delegation pattern: Both patterns use a protocol for flexibility. Unlike the delegation pattern, however, strategies are meant to be switched at runtime, whereas delegates are usually fixed.
