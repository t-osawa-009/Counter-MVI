import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            let viewState = CounterViewState()
            let intent = CounterIntent(viewState: viewState,
                                       apiService: CounterAPIService())
            CounterView(viewState: viewState, intent: intent)
        }
    }
}
