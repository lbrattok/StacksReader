import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let contentHTML: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let templateURL = Bundle.module.url(forResource: "template", withExtension: "html"),
              let templateString = try? String(contentsOf: templateURL) else { return }

        let finalHTML = templateString.replacingOccurrences(of: "{{STACKS_CONTENT}}", with: contentHTML)

        guard let baseUrl = Bundle.module.resourceURL else {
            uiView.loadHTMLString(finalHTML, baseURL: nil)
            return
        }

        uiView.loadHTMLString(finalHTML, baseURL: baseUrl)
    }
}
