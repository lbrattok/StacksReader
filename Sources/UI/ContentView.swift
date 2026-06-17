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
                    ProgressView("Скачивание томов...")
                        .scaleEffect(1.2)
                        .padding()
                        .background(Color(UIColor.systemBackground).opacity(0.9))
                        .cornerRadius(12)
                }
            }
            .navigationTitle("Stacks Project")

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
            "0001", // Part 1: Preliminaries
            "0ELP", // Part 2: Schemes
            "0ELV", // Part 3: Topics in Scheme Theory
            "0ELT", // Part 4: Algebraic Spaces
            "0ELN", // Part 5: Topics in Geometry
            "0ELW", // Part 6: Deformation Theory
            "0ELR"  // Part 8: Topics in Moduli Theory
        ]

        let fetchedParts = await withTaskGroup(of: (Int, Structure?).self) { group in

            for (index, tag) in partTags.enumerated() {
                group.addTask {
                    do {
                        let jsonStr = try await NetworkManager.shared.fetchTagStructure(tag: tag)
                        let cppRoot = jsonStr.withCString { cString in
                            Structure(std.string(cString))
                        }
                        return (index, cppRoot)
                    } catch {
                        print("Ошибка загрузки \(tag): \(error)")
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
