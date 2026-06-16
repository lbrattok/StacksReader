import SwiftUI
import Core

struct ContentView: View {
    @State private var htmlContent: String = ""
    @State private var isLoading: Bool = true

    let currentTag = "015I"

    var body: some View {
        NavigationView {
            ZStack {
                if !htmlContent.isEmpty {
                    WebView(contentHTML: htmlContent)
                        .edgesIgnoringSafeArea(.bottom)
                }

                if isLoading {
                    ProgressView("Загрузка")
                        .scaleEffect(1.2)
                }
            }
            .navigationTitle("Tag \(currentTag)")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadData()
            }
        }
    }

    private func loadData() async {
        isLoading = true
        do {
            let result = try await NetworkManager.shared.fetchTagContent(tag: currentTag)

            htmlContent = result
            isLoading = false
        } catch {
            htmlContent = "<p style='color:red'>Ошибка загрузки: \(error.localizedDescription)</p>"
            isLoading = false
        }
    }
}
