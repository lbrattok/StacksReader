import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let contentHTML: String
    let onTagSelected: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onTagSelected: onTagSelected)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        let jsCode = """
        document.addEventListener('click', function(event) {
            var target = event.target.closest('a');
            if (!target) return;

            var href = target.getAttribute('href');
            if (!href) return;

            if (href.startsWith('#')) {
                return;
            }

            var match = href.match(/\\/tag\\/([a-zA-Z0-9]{4})/i);
            if (match) {
                var tag = match[1].toUpperCase();

                var existsOnPage = document.getElementById(tag) || 
                                   document.getElementById(tag.toLowerCase()) || 
                                   document.querySelector('[name="' + tag + '"]') ||
                                   document.querySelector('[name="' + tag.toLowerCase() + '"]');

                if (existsOnPage) {
                    event.preventDefault();
                    existsOnPage.scrollIntoView({behavior: 'smooth', block: 'start'});
                    return;
                }

                event.preventDefault();
                window.webkit.messageHandlers.linkBridge.postMessage(tag);
                return;
            }

            event.preventDefault();
        }, true);
        """
        let script = WKUserScript(source: jsCode, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)

        config.userContentController.add(context.coordinator, name: "linkBridge")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != nil { return }

        guard let templateURL = Bundle.module.url(forResource: "template", withExtension: "html"),
              let templateString = try? String(contentsOf: templateURL) else { return }

        let finalHTML = templateString.replacingOccurrences(of: "{{STACKS_CONTENT}}", with: contentHTML)

        guard let baseUrl = Bundle.module.resourceURL else {
            uiView.loadHTMLString(finalHTML, baseURL: nil)
            return
        }
        uiView.loadHTMLString(finalHTML, baseURL: baseUrl)
    }

    class Coordinator: NSObject, WKScriptMessageHandler {
        let onTagSelected: (String) -> Void

        init(onTagSelected: @escaping (String) -> Void) {
            self.onTagSelected = onTagSelected
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "linkBridge", let tag = message.body as? String {
                onTagSelected(tag)
            }
        }
    }
}
