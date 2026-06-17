import Foundation
import CppBack

extension Structure: @unchecked Sendable {}

extension Structure: @retroactive Identifiable {
    public var id: String { 
        String(self.tag()) 
    }

    public var swiftName: String { String(self.name()) }
    public var swiftType: String { String(self.type()) }
    public var swiftReference: String { String(self.reference()) }

    public var swiftChildren: [Structure] { 
        Array(self.children()) 
    }
}
