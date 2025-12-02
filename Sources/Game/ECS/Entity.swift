import Foundation

/// A unique identifier for an entity in the ECS system.
public struct Entity: Sendable, Hashable, Codable {
    public let id: UUID

    public init(id: UUID = UUID()) {
        self.id = id
    }

    /// Creates a new entity with a unique identifier.
    public static func create() -> Entity {
        Entity()
    }
}

// MARK: - CustomStringConvertible

extension Entity: CustomStringConvertible {
    public var description: String {
        "Entity(\(id.uuidString.prefix(8)))"
    }
}
