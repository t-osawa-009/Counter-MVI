import Testing
@testable import Counter

struct CounterViewStateTests {

    @Test func 値が増加する() async throws {
        let viewState = CounterViewState()
        viewState.increment()
        
        #expect(viewState.count == 1)
    }
    
    @Test func 値が減少する() async throws {
        let viewState = CounterViewState()
        viewState.decrement()
        
        #expect(viewState.count == -1)
    }
    
    @Test func 値がリセットされる() async throws {
        let viewState = CounterViewState()
        viewState.increment()
        viewState.reset()
        
        #expect(viewState.count == 0)
    }
}
