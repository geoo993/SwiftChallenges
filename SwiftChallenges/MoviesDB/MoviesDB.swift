import SCDomain
import SCAPIClient
import ComposableArchitecture

struct MoviesDB: ReducerProtocol {
    typealias Page = Pagination<Movie>
    
    struct State: Equatable {
        var movies: [Movie] = []
        var activeGenre: Genre = .all
        var carouselMode: Bool = true
        var pagination: Page.State = .init()
    }

    enum Action: Equatable {
        case getMovies
        case didLoad(TaskResult<[Movie]>)
        case toggleCarouselMode
        case didSelectGenre(Genre)
        case willDisplayNextRow(atIndex: Int)
        case pagination(Page.Action)
    }

    @Dependency(\.repository) var repository
    private enum TrendingMoviesID {}
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.pagination, action: /Action.pagination) {
            Pagination<Movie>()
        }
        Reduce { state, action in
            switch action {
            case .getMovies:
                state.movies = []
                return EffectTask(value: .pagination(.loadFirstPage))
            case .pagination(.loadFirstPage), .pagination(.loadNextPage):
                return .run { [page = state.pagination.page] send in
                    await send(.pagination(.didChangeLoadingStatus(true)))
                    await send(
                        .didLoad(TaskResult { try await repository.getTrendingMovies(page: page) })
                    )
                    await send(.pagination(.didChangeLoadingStatus(false)))
                }
                .cancellable(id: TrendingMoviesID.self)
            case let .didLoad(.success(result)):
                return EffectTask(value: .pagination(.didLoadPages(result)))
            case let .pagination(.updatePages(.current(result))),
                let .pagination(.updatePages(.next(result))):
                state.movies += result
                return .none
            case .didLoad(.failure):
                state.movies = []
                return .cancel(id: TrendingMoviesID.self)
            case .toggleCarouselMode:
                state.carouselMode.toggle()
                return .none
            case let .didSelectGenre(value):
                state.activeGenre = value
                return .none
            case let .willDisplayNextRow(index):
                guard state.activeGenre == .all else { return .none }
                return EffectTask(value: .pagination(.willDisplayNextRow(atIndex: index)))
            default:
                return .none
            }
        }
    }
}

extension MoviesDB.State {
    var filteredMovies: [Movie] {
        activeGenre == .all
        ? movies
        : movies.filter { $0.genres.contains(activeGenre) }
    }
    
    var totalMovies: Int {
        activeGenre == .all ? movies.count : filteredMovies.count
    }
}
