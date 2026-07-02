import Foundation

public actor CacheManager {
    public static let shared = CacheManager()

    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent("StacksCache")

        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    public func savePage(tag: String, htmlContent: String) {
        let fileURL = cacheDirectory.appendingPathComponent("\(tag).html")
        guard let data = htmlContent.data(using: .utf8) else { return }
        try? data.write(to: fileURL)
    }

    public func getPage(tag: String) -> String? {
        let fileURL = cacheDirectory.appendingPathComponent("\(tag).html")
        guard let data = try? Data(contentsOf: fileURL),
              let html = String(data: data, encoding: .utf8) else {
            return nil
        }
        return html
    }

    public func saveTOC(tag: String, jsonString: String) {
        let fileURL = cacheDirectory.appendingPathComponent("toc_\(tag).dat")
        guard let data = jsonString.data(using: .utf8) else { return }
        try? data.write(to: fileURL)
    }

    public func getTOC(tag: String) -> String? {
        let fileURL = cacheDirectory.appendingPathComponent("toc_\(tag).dat")
        guard let data = try? Data(contentsOf: fileURL),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
}
