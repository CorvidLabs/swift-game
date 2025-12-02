import Foundation

/// The result of a collision detection query.
public struct CollisionResult: Sendable, Hashable {
    /// Whether a collision occurred.
    public let collided: Bool

    /// The point of contact (if collision occurred).
    public let contactPoint: Vec2?

    /// The collision normal (if collision occurred).
    public let normal: Vec2?

    /// The penetration depth (if collision occurred).
    public let depth: Double?

    public init(
        collided: Bool,
        contactPoint: Vec2? = nil,
        normal: Vec2? = nil,
        depth: Double? = nil
    ) {
        self.collided = collided
        self.contactPoint = contactPoint
        self.normal = normal
        self.depth = depth
    }

    /// A result indicating no collision.
    public static let noCollision = CollisionResult(collided: false)

    /// Creates a collision result with full information.
    public static func collision(
        at point: Vec2,
        normal: Vec2,
        depth: Double
    ) -> CollisionResult {
        CollisionResult(
            collided: true,
            contactPoint: point,
            normal: normal,
            depth: depth
        )
    }
}
