import Foundation

public final class NetworkManager: Sendable {
    public static let shared = NetworkManager()

    private init() {}

    public func fetchTagContent(tag: String) async throws -> String {
        let urlString = "https://stacks.math.columbia.edu/data/tag/\(tag)/content/full"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        if let htmlString = String(data: data, encoding: .utf8) {
            return htmlString
        } else {
            throw URLError(.cannotDecodeRawData)
        }
    }

    public func fetchTagStructure(tag: String) async throws -> String {
        let urlString = "https://stacks.math.columbia.edu/data/tag/\(tag)/structure"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)

        if let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        } else {
            throw URLError(.cannotDecodeRawData)
        }
    }
}
