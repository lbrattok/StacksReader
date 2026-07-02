import SwiftUI
import Core

struct TagDetailView: View {
    let tag: String

    @StateObject private var viewModel = TagViewModel()
    @State private var selectedNestedTag: String? = nil

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .scaleEffect(1.2)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Network error").font(.headline).foregroundColor(.red)
                    Text(errorMessage).foregroundColor(.secondary).multilineTextAlignment(.center).padding()
                    Button("Retry") { Task { await viewModel.loadTag(tag) } }.buttonStyle(.bordered)
                }
            } else if !viewModel.contentHTML.isEmpty {

                WebView(contentHTML: viewModel.contentHTML) { clickedTag in
                    self.selectedNestedTag = clickedTag
                }
                .edgesIgnoringSafeArea(.bottom)

            } else {
                Text("No data found").foregroundColor(.secondary)
            }
        }
        .navigationTitle("Tag \(tag)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedNestedTag) { next in
            TagDetailView(tag: next)
        }
        .task {
            await viewModel.loadTag(tag)
        }
    }
}
