import SwiftUI

struct ContentView: View {
    let sampleStacksContent = """
    <p>Let \\(X\\) be a scheme. A morphism of schemes \\(f: X \\to Y\\) is called <em>affine</em> if the inverse image of every affine open \\(V \\subset Y\\) is an affine open of \\(X\\).</p>
    <p>Consider the following equation:</p>
    $$ \\int_{a}^{b} x^2 dx = \\frac{b^3 - a^3}{3} $$
    <p>This is a test of block and inline math rendering.</p>
    """

    var body: some View {
        NavigationView {
            VStack {
                WebView(contentHTML: sampleStacksContent)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .navigationTitle("Stacks Project")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
