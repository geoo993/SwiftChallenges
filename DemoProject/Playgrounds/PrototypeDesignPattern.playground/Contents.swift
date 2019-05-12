import UIKit

// The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone. This practise is particularly useful when the construction of a new object is inefficient.
enum FootballTeam {
    case chelsea
    case arsenal
    case liverpool
    case everton
}
enum BasketballTeam {
    case thunder
    case rockets
    case bostonceltics
    case lakers
}

enum Sport {
    case football
    case basketball
}
enum Event {
    case premiership(FootballTeam, FootballTeam)
    case nbaplayoff(BasketballTeam, BasketballTeam)
}
protocol Game {
    var sport: Sport { get }
    var event: Event { get }
    var score: (Int, Int) { get set }
    mutating func setupScore(teamA: Int, teamB: Int)
    func printScore()
    func clone() -> Game
}

struct BasketballGame: Game {
    var sport: Sport
    var event: Event
    var score: (Int, Int)
    init(teamA: BasketballTeam, teamB: BasketballTeam) {
        sport = .basketball
        event = .nbaplayoff(teamA, teamB)
        score = (0, 0)
    }
    private init(basketballGame: BasketballGame) {
        // Setup here
        self.sport = basketballGame.sport
        self.event = basketballGame.event
        self.score = basketballGame.score
        printScore()
    }
    mutating func setupScore( teamA: Int, teamB: Int) {
        // More setup here, as we cannot customize via init here
        self.score = (teamA, teamB)
        printScore()
    }
    func printScore() {
        switch event {
        case .nbaplayoff(let A, let B):
            print("\(A) \(self.score.0) vs \(B) \(self.score.1)")
        default:break
        }
    }
    func clone() -> Game {
        return BasketballGame(basketballGame: self)
    }
}

struct FootballGame: Game {
    var sport: Sport
    var event: Event
    var score: (Int, Int)
    init(teamA: FootballTeam, teamB: FootballTeam) {
        sport = .football
        event = .premiership(teamA, teamB)
        score = (0, 0)
    }
    private init(footballGame: FootballGame) {
        self.sport = footballGame.sport
        self.event = footballGame.event
        self.score = footballGame.score
        printScore()
    }
    mutating func setupScore(teamA: Int, teamB: Int) {
        self.score = (teamA, teamB)
        printScore()
    }
    func printScore() {
        switch event {
        case .premiership(let A, let B):
            print("\(A) \(self.score.0) vs \(B) \(self.score.1)")
        default:break
        }
    }
    func clone() -> Game {
        return FootballGame(footballGame: self)
    }
}

class HalfTimeScoreViewController: UIViewController {
    var game: Game!
    init(game: Game) {
        super.init(nibName: nil, bundle: nil)
        print("game is half time")
        self.game = game.clone()
        print()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        print("loading view with game")
    }
}


class FinalScoreViewController: UIViewController {
    var game: Game!
    init(game: Game) {
        super.init(nibName: nil, bundle: nil)
        print("Final score")
        self.game = game.clone()
        switch self.game.event {
        case .nbaplayoff(let A, let B):
            if self.game.score.0 > self.game.score.1 {
                print("\(A) win by \(self.game.score.0 - self.game.score.1) points")
            } else if self.game.score.0 < self.game.score.1 {
                print("\(B) win by \(self.game.score.0 - self.game.score.1) points")
            } else {
                print("\(A) and \(B) ended in draw")
            }
        case .premiership(let A, let B):
            if self.game.score.0 > self.game.score.1 {
                print("\(A) win by \(self.game.score.0 - self.game.score.1) goals")
            } else if self.game.score.0 < self.game.score.1 {
                 print("\(B) win by \(self.game.score.0 - self.game.score.1) goals")
            } else {
                print("\(A) and \(B) ended in draw")
            }
            print()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        print("loading view with game")
    }
}


var basketallGame = BasketballGame(teamA: .lakers, teamB: .rockets)
basketallGame.setupScore(teamA: 17, teamB: 20)

var footballGame = FootballGame(teamA: .arsenal, teamB: .liverpool)
footballGame.setupScore(teamA: 1, teamB: 0)
footballGame.setupScore(teamA: 1, teamB: 1)
var htViewController = HalfTimeScoreViewController(game: footballGame)
footballGame.setupScore(teamA: 2, teamB: 1)
footballGame.setupScore(teamA: 3, teamB: 1)
footballGame.setupScore(teamA: 4, teamB: 1)
var ftViewController = FinalScoreViewController(game: footballGame)

basketallGame.setupScore(teamA: 47, teamB: 53)
htViewController = HalfTimeScoreViewController(game: basketallGame)

basketallGame.setupScore(teamA: 77, teamB: 86)

basketallGame.setupScore(teamA: 121, teamB: 116)
ftViewController = FinalScoreViewController(game: basketallGame)
