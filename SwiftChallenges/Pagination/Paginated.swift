import ComposableArchitecture

enum Paginated<T: Equatable>: Equatable {
    case current(T)
    case next(T)
}

struct Pagination<T: Equatable>: ReducerProtocol {
    struct State: Equatable {
        var offset: Int
        var limit: Int
        var page: Int = 0
        var status: Status = .first
        let nextPageThreshold = 3
        var canLoadNextPage: Bool = true
        var isLoading = true

        init(
            offset: Int = 0,
            limit: Int = 20,
            canLoadNextPage: Bool = true
        ) {
            self.offset = offset
            self.limit = limit
            self.canLoadNextPage = canLoadNextPage
        }
    }
    
    enum Status: Equatable {
        case first, next
    }

    enum Action: Equatable {
        case loadFirstPage
        case loadNextPage
        case willDisplayNextRow(atIndex: Int)
        case didChangeLoadingStatus(Bool)
        case didLoadPages([T])
        case updatePages(Paginated<[T]>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loadFirstPage:
            state.status = .first
            state.offset = 0
            state.page = 1
            state.canLoadNextPage = true
            return .none
        case .loadNextPage:
            state.status = .next
            return .none
        case let .didChangeLoadingStatus(loading):
            state.isLoading = loading
            return .none
        case let .willDisplayNextRow(index):
            let didPassThreshold = index >= state.offset - state.nextPageThreshold
            guard didPassThreshold, state.canLoadNextPage, !state.isLoading else { return .none }
            return EffectTask(value: .loadNextPage)
        case let .didLoadPages(values):
            state.canLoadNextPage = values.count >= state.limit
            state.offset += values.count
            state.page += 1
            if state.status == .first {
                return EffectTask(value: .updatePages(.current(values)))
            }
            return EffectTask(value: .updatePages(.next(values)))
        default:
            return .none
        }
    }
}
