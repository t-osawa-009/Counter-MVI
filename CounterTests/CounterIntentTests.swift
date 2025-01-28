import Testing
@testable import Counter

struct CounterIntentTests {

    @Test func Incrementをタップすると値が増加する() async throws {
        let viewState = CounterViewState()
        let apiService = CounterAPIService()
        let intent = CounterIntent(viewState: viewState, apiService: apiService)
        intent.tapIncrement()
        
        #expect(viewState.count == 1)
    }
    
    @Test func Decrementをタップすると値が増加する() async throws {
        let viewState = CounterViewState()
        let apiService = CounterAPIService()
        let intent = CounterIntent(viewState: viewState, apiService: apiService)
        intent.tapDecrement()
        
        #expect(viewState.count == -1)
    }
    
    @Test func リセットをタップすると値がリセットされる() async throws {
        let viewState = CounterViewState()
        let apiService = CounterAPIService()
        let intent = CounterIntent(viewState: viewState, apiService: apiService)
        intent.tapDecrement()
        
        intent.tapReset()
        
        #expect(viewState.count == 0)
    }
}

