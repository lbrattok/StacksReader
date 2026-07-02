import Foundation

public final class NetworkManager: Sendable {
    public static let shared = NetworkManager()

    private init() {}

    public func fetchTag(tag: String) async throws -> String {
        let urlString = "https://stacks.math.columbia.edu/data/tag/\(tag)/content/full"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let dataString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeRawData)
        }

        return dataString
    }
}
