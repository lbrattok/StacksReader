import SwiftUI

@MainActor
public class TagViewModel: ObservableObject {
    @Published public var contentHTML: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    public init() {}

    public func loadTag(_ tag: String) async {
        guard !tag.isEmpty else { return }

        guard contentHTML.isEmpty else { return }

        isLoading = true
        errorMessage = nil


        defer { isLoading = false }

        if let cachedHTML = await CacheManager.shared.getPage(tag: tag) {
            self.contentHTML = cachedHTML
            return
        }

        do {
            let parsedHTML = try await NetworkManager.shared.fetchTag(tag: tag)

            await CacheManager.shared.savePage(tag: tag, htmlContent: parsedHTML)

            self.contentHTML = parsedHTML

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
