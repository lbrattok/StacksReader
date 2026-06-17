import SwiftUI
import Core
import CppBack

struct StaticStructureView: View {
    let node: Structure
    let onTagSelected: (String) -> Void

    var level: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                if node.swiftChildren.isEmpty {
                    onTagSelected(node.id)
                }
            }) {
                HStack(alignment: .top) {
                    Text("\(node.swiftType.prefix(1).capitalized). \(node.swiftReference)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 50, alignment: .leading)

                    VStack(alignment: .leading) {
                        Text(node.swiftName.isEmpty ? "No name" : node.swiftName)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)

                        Text(node.id)
                            .font(.caption2.monospaced())
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 6)
                .padding(.leading, CGFloat(level * 16)) 
            }
            .buttonStyle(PlainButtonStyle())

            ForEach(node.swiftChildren) { child in
                StaticStructureView(
                    node: child,
                    onTagSelected: onTagSelected,
                    level: level + 1
                )
            }
        }
    }
}
