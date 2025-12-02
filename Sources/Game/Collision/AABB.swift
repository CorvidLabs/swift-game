import Foundation

/// Axis-Aligned Bounding Box for collision detection.
public struct AABB: Sendable, Hashable, Codable {
    /// The minimum corner of the bounding box.
    public let min: Vec2

    /// The maximum corner of the bounding box.
    public let max: Vec2

    public init(min: Vec2, max: Vec2) {
        self.min = min
        self.max = max
    }

    /// Creates an AABB from center position and size.
    public init(center: Vec2, size: Vec2) {
        let halfSize = size / 2
        self.min = center - halfSize
        self.max = center + halfSize
    }

    /// Creates an AABB from position and size (position is top-left).
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.min = Vec2(x: x, y: y)
        self.max = Vec2(x: x + width, y: y + height)
    }

    /// The center point of the bounding box.
    public var center: Vec2 {
        (min + max) / 2
    }

    /// The size (width and height) of the bounding box.
    public var size: Vec2 {
        max - min
    }

    /// The width of the bounding box.
    public var width: Double {
        max.x - min.x
    }

    /// The height of the bounding box.
    public var height: Double {
        max.y - min.y
    }

    /// The extents (half-size) of the bounding box.
    public var extents: Vec2 {
        size / 2
    }

    /// Checks if this AABB contains a point.
    public func contains(_ point: Vec2) -> Bool {
        point.x >= min.x && point.x <= max.x &&
        point.y >= min.y && point.y <= max.y
    }

    /// Checks if this AABB intersects with another AABB.
    public func intersects(_ other: AABB) -> Bool {
        !(max.x < other.min.x || min.x > other.max.x ||
          max.y < other.min.y || min.y > other.max.y)
    }

    /// Checks if this AABB fully contains another AABB.
    public func contains(_ other: AABB) -> Bool {
        other.min.x >= min.x && other.max.x <= max.x &&
        other.min.y >= min.y && other.max.y <= max.y
    }

    /// Returns the collision result between this AABB and another.
    public func collisionResult(with other: AABB) -> CollisionResult {
        guard intersects(other) else { return .noCollision }

        let overlapX = Swift.min(max.x, other.max.x) - Swift.max(min.x, other.min.x)
        let overlapY = Swift.min(max.y, other.max.y) - Swift.max(min.y, other.min.y)

        let depth: Double
        let normal: Vec2

        if overlapX < overlapY {
            depth = overlapX
            normal = center.x < other.center.x ? Vec2(x: -1, y: 0) : Vec2(x: 1, y: 0)
        } else {
            depth = overlapY
            normal = center.y < other.center.y ? Vec2(x: 0, y: -1) : Vec2(x: 0, y: 1)
        }

        let contactPoint = center + normal * (extents.x * abs(normal.x) + extents.y * abs(normal.y))

        return .collision(at: contactPoint, normal: normal, depth: depth)
    }

    /// Returns the closest point on the AABB to the given point.
    public func closestPoint(to point: Vec2) -> Vec2 {
        Vec2(
            x: Swift.max(min.x, Swift.min(max.x, point.x)),
            y: Swift.max(min.y, Swift.min(max.y, point.y))
        )
    }

    /// Expands the AABB by the given amount in all directions.
    public func expanded(by amount: Double) -> AABB {
        AABB(
            min: min - Vec2(x: amount, y: amount),
            max: max + Vec2(x: amount, y: amount)
        )
    }

    /// Returns the union of this AABB with another.
    public func union(with other: AABB) -> AABB {
        AABB(
            min: Vec2(
                x: Swift.min(min.x, other.min.x),
                y: Swift.min(min.y, other.min.y)
            ),
            max: Vec2(
                x: Swift.max(max.x, other.max.x),
                y: Swift.max(max.y, other.max.y)
            )
        )
    }

    /// Returns the intersection of this AABB with another, if they intersect.
    public func intersection(with other: AABB) -> AABB? {
        guard intersects(other) else { return nil }

        return AABB(
            min: Vec2(
                x: Swift.max(min.x, other.min.x),
                y: Swift.max(min.y, other.min.y)
            ),
            max: Vec2(
                x: Swift.min(max.x, other.max.x),
                y: Swift.min(max.y, other.max.y)
            )
        )
    }
}
