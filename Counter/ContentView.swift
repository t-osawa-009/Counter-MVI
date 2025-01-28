import SwiftUI
import Combine

protocol APIService {
    func fetchCount() async throws -> Int
    func updateCount(newCount: Int) async throws
}

enum CounterAPIError: Error, LocalizedError {
    case networkError
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection lost."
        case .invalidResponse:
            return "Invalid response from server."
        }
    }
}

// MARK: - API Service
final class CounterAPIService: APIService {
    private let fetchCount: Int
    
    init(fetchCount: Int = 42) {
        self.fetchCount = fetchCount
    }
    
    func fetchCount() async throws -> Int {
        // 実際のAPIリクエストをここに実装
        // 例として仮のデータを返す
        try await Task.sleep(nanoseconds: 500_000_000) // 模擬的な遅延
        return fetchCount // サーバーから取得した仮のデータ
    }

    func updateCount(newCount: Int) async throws {
        // 新しいカウント値をサーバーに送信
        try await Task.sleep(nanoseconds: 500_000_000) // 模擬的な遅延
        // サーバーに送信成功と仮定
    }
}

final class ErrorCounterAPIService: APIService {
    func fetchCount() async throws -> Int {
        // 実際のAPIリクエストをここに実装
        // 例として仮のデータを返す
        try await Task.sleep(nanoseconds: 500_000_000) // 模擬的な遅延
        throw CounterAPIError.invalidResponse
    }

    func updateCount(newCount: Int) async throws {
        // 新しいカウント値をサーバーに送信
        try await Task.sleep(nanoseconds: 500_000_000) // 模擬的な遅延
        // サーバーに送信成功と仮定
    }
}

// MARK: - ViewState (Model)
final class CounterViewState: ObservableObject {
    @Published var count: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func updateError(errorMessage: String) {
        self.errorMessage = errorMessage
    }

    @MainActor
    func updateCount(newCount: Int) async {
        errorMessage = nil
        count = newCount
    }

    func increment() {
        count += 1
    }

    func decrement() {
        count -= 1
    }

    func reset() {
        count = 0
    }
    
    @MainActor
    func startLoading() {
        isLoading = true
    }
    
    @MainActor
    func stopLoading() {
        isLoading = false
    }
}

// MARK: - Intent
final class CounterIntent {
    weak var viewState: CounterViewState?
    private let apiService: APIService

    init(viewState: CounterViewState, apiService: APIService = CounterAPIService()) {
        self.viewState = viewState
        self.apiService = apiService
    }

    func tapIncrement() {
        guard let viewState = viewState else { return }
        viewState.increment()
    }

    func tapDecrement() {
        guard let viewState = viewState else { return }
        viewState.decrement()
    }

    func tapReset() {
        guard let viewState = viewState else { return }
        viewState.reset()
    }

    func handleOnAppear() {
        guard let viewState = viewState else { return }
        Task {
            do {
                await viewState.startLoading()
                let count = try await apiService.fetchCount()
                await viewState.stopLoading()
                await viewState.updateCount(newCount: count)
            } catch {
                await viewState.stopLoading()
                viewState.updateError(errorMessage: "Failed to fetch count: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - View
struct CounterView: View {
    @StateObject private var viewState: CounterViewState
    private let intent: CounterIntent

    init(viewState: CounterViewState, intent: CounterIntent) {
        _viewState = .init(wrappedValue: viewState)
        self.intent = intent
    }

    var body: some View {
        VStack {
            if viewState.isLoading {
                ProgressView("Loading...")
            } else {
                Text("Count: \(viewState.count)")
                    .font(.system(size: 40))
            }

            if let errorMessage = viewState.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 30))
            }
            
            VStack(spacing: 15, content: {
                Button(action: {
                    intent.tapIncrement()
                }) {
                    Text("Increment")
                        .font(.system(size: 40))
                }
                
                Button(action: {
                    intent.tapDecrement()
                }) {
                    Text("Decrement")
                        .font(.system(size: 40))
                }
                
                Button(action: {
                    intent.tapReset()
                }) {
                    Text("Reset")
                        .font(.system(size: 40))
                }
            })
            .padding()
        }.onAppear {
            intent.handleOnAppear()
        }
        .padding()
    }
}

// MARK: - Preview
#Preview("正常系") {
    let viewState = CounterViewState()
    let intent = CounterIntent(viewState: viewState,
                               apiService: CounterAPIService())
    CounterView(viewState: viewState, intent: intent)
}

// MARK: - Preview
#Preview("エラー") {
    let viewState = CounterViewState()
    let intent = CounterIntent(viewState: viewState,
                               apiService: ErrorCounterAPIService())
    CounterView(viewState: viewState, intent: intent)
}

