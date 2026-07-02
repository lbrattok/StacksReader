import SwiftUI
import Core
import CppBack
import CxxStdlib

struct ContentView: View {
    @State private var tableOfContents: [Structure] = []

    @State private var selectedTag: String? = nil

    @State private var isTocLoading: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(tableOfContents) { rootNode in
                        StructureView(node: rootNode) { tag in
                            self.selectedTag = tag
                        }
                    }
                }
                .padding()

                if isTocLoading {
                    ProgressView("Loading...")
                        .scaleEffect(1.2)
                        .padding()
                        .background (Color(UIColor.systemBackground).opacity(0.9))
                        .cornerRadius(12)
                }
            }
            .navigationTitle("The Stacks Project")

            .navigationDestination(item: $selectedTag) { tag in
                TagDetailView(tag: tag)
            }
        }
        .task {
            await loadTableOfContents()
        }
    }


    private func loadTableOfContents() async {
        isTocLoading = true

        let partTags = [
            "0ELQ", // Part 1: Preliminaries
            "0ELP", // Part 2: Schemes
            "0ELV", // Part 3: Topics in Scheme Theory
            "0ELT", // Part 4: Algebraic Spaces
            "0ELN", // Part 5: Topics in Geometry
            "0ELW", // Part 6: Deformation Theory
            "0ELS", // Part 7: Algebraic Stacks
            "0ELR", // Part 8: Topics in Moduli Theory
            "0ELU"  // Part 9: Miscellany
        ]

        let fetchedParts = await withTaskGroup(of: (Int, Structure?).self) { group in

            for (index, tag) in partTags.enumerated() {
                group.addTask {
                    do {
                        let jsonStr: String

                        if let cachedJSON = await CacheManager.shared.getTOC(tag: tag) {
                            jsonStr = cachedJSON
                        } else {
                            jsonStr = try await NetworkManager.shared.fetchTag(tag: tag)
                            await CacheManager.shared.saveTOC(tag: tag, jsonString: jsonStr)
                        }

                        let cppRoot = jsonStr.withCString { cString in
                            Structure(std.string(cString))
                        }

                        return (index, cppRoot)
                    } catch {
                        return (index, nil)
                    }
                }
            }

            var results: [(Int, Structure)] = []
            for await result in group {
                if let root = result.1 {
                    results.append((result.0, root))
                }
            }

            return results.sorted(by: { $0.0 < $1.0 }).map { $1 }
        }

        self.tableOfContents = fetchedParts
        isTocLoading = false
    }
}
