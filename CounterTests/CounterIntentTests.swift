import Testing
@testable import Counter

// MARK: - API Service
final class TestCounterAPIService: APIService {
    private let fetchCount: Int
    
    init(fetchCount: Int = 42) {
        self.fetchCount = fetchCount
    }
    
    func fetchCount() async throws -> Int {
        return fetchCount // サーバーから取得した仮のデータ
    }

    func updateCount(newCount: Int) async throws {}
}

struct CounterIntentTests {
    
    @Test func onAppearの時に最新の値で更新される() async throws {
        let viewState = CounterViewState()
        let apiService = TestCounterAPIService(fetchCount: 100)
        let intent = CounterIntent(viewState: viewState, apiService: apiService)
        intent.handleOnAppear()
        
        #expect(viewState.count == 100)
    }

    @Test func Incrementをタップすると値が増加する() async throws {
        let viewState = CounterViewState()
        let apiService = TestCounterAPIService()
        let intent = CounterIntent(viewState: viewState, apiService: apiService)
        intent.tapIncrement()
        
        #expect(viewState.count == 1)
    }
    
    @Test func Decrementをタップすると値が増加する() async throws {
        let viewState = CounterViewState()
        let apiService = TestCounterAPIService()
        let intent = CounterIntent(viewState: viewState, apiService: apiService)
        intent.tapDecrement()
        
        #expect(viewState.count == -1)
    }
    
    @Test func リセットをタップすると値がリセットされる() async throws {
        let viewState = CounterViewState()
        let apiService = TestCounterAPIService()
        let intent = CounterIntent(viewState: viewState, apiService: apiService)
        intent.tapDecrement()
        
        intent.tapReset()
        
        #expect(viewState.count == 0)
    }
}

