import Foundation

/// A ray for raycasting operations.
public struct Ray: Sendable, Hashable {
    /// The origin point of the ray.
    public let origin: Vec2

    /// The direction of the ray (should be normalized).
    public let direction: Vec2

    public init(origin: Vec2, direction: Vec2) {
        self.origin = origin
        self.direction = direction.normalized()
    }

    /// Creates a ray from an origin pointing towards a target.
    public static func towards(origin: Vec2, target: Vec2) -> Ray {
        Ray(origin: origin, direction: target - origin)
    }

    /// Returns a point along the ray at the given distance.
    public func point(at distance: Double) -> Vec2 {
        origin + direction * distance
    }

    /// Casts the ray against a circle and returns the hit distance if it hits.
    public func cast(circle: Circle, maxDistance: Double = .infinity) -> Double? {
        let toCircle = circle.center - origin
        let projection = toCircle.dot(direction)

        // Circle is behind the ray
        guard projection >= 0 else { return nil }

        let closestPoint = origin + direction * projection
        let distanceSquared = closestPoint.distanceSquared(to: circle.center)
        let radiusSquared = circle.radius * circle.radius

        // Ray misses the circle
        guard distanceSquared <= radiusSquared else { return nil }

        let offset = sqrt(radiusSquared - distanceSquared)
        let distance = projection - offset

        guard distance >= 0 && distance <= maxDistance else { return nil }

        return distance
    }

    /// Casts the ray against an AABB and returns the hit distance if it hits.
    public func cast(aabb: AABB, maxDistance: Double = .infinity) -> Double? {
        let invDir = Vec2(
            x: direction.x != 0 ? 1 / direction.x : .infinity,
            y: direction.y != 0 ? 1 / direction.y : .infinity
        )

        let t1 = (aabb.min.x - origin.x) * invDir.x
        let t2 = (aabb.max.x - origin.x) * invDir.x
        let t3 = (aabb.min.y - origin.y) * invDir.y
        let t4 = (aabb.max.y - origin.y) * invDir.y

        let tmin = Swift.max(Swift.min(t1, t2), Swift.min(t3, t4))
        let tmax = Swift.min(Swift.max(t1, t2), Swift.max(t3, t4))

        // Ray misses the AABB
        guard tmax >= 0 && tmin <= tmax else { return nil }

        let distance = tmin >= 0 ? tmin : tmax

        guard distance <= maxDistance else { return nil }

        return distance
    }
}
