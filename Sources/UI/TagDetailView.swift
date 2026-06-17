import SwiftUI
import Core

struct TagDetailView: View {
    let tag: String

    @State private var htmlContent: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Загрузка...")
                    .scaleEffect(1.2)
            } else if !htmlContent.isEmpty {
                WebView(contentHTML: htmlContent)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                Text("Данные не найдены")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Tag \(tag)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadData()
        }
    }

    private func loadData() async {
        guard !tag.isEmpty else { return }

        isLoading = true
        do {
            let result = try await NetworkManager.shared.fetchTagContent(tag: tag)
            htmlContent = result
        } catch {
            htmlContent = "<p style='color:red'>Ошибка сети: \(error.localizedDescription)</p>"
        }
        isLoading = false
    }
}
