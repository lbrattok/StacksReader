import SwiftUI
import Core
import CppBack
import CxxStdlib

struct ContentView: View {
    @State private var tableOfContents: [Structure] = []

    @State private var selectedTag: String? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(tableOfContents) { rootNode in
                        StaticStructureView(node: rootNode) { tag in
                            self.selectedTag = tag
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Stacks Project")

            .navigationDestination(item: $selectedTag) { tag in
                TagDetailView(tag: tag)
            }
        }
        .onAppear {
            loadMockStructure()
        }
    }


    private func loadMockStructure() {
        let jsonStr = """
        {
        "tag": "0001",
        "name": "Part 1: Preliminaries",
        "type": "part",
        "reference": "I",
        "children": [
            {
            "tag": "015I",
            "name": "Affine Morphisms of Schemes",
            "type": "lemma",
            "reference": "1.1",
            "children": []
            }
        ]
        }
        """

        let cppRoot = jsonStr.withCString { cString in
            Structure(std.string(cString))
        }

        self.tableOfContents = [cppRoot]
    }
}
