import Foundation

/// A circle for collision detection.
public struct Circle: Sendable, Hashable, Codable {
    /// The center position of the circle.
    public let center: Vec2

    /// The radius of the circle.
    public let radius: Double

    public init(center: Vec2, radius: Double) {
        self.center = center
        self.radius = radius
    }

    public init(x: Double, y: Double, radius: Double) {
        self.center = Vec2(x: x, y: y)
        self.radius = radius
    }

    /// The diameter of the circle.
    public var diameter: Double {
        radius * 2
    }

    /// The area of the circle.
    public var area: Double {
        .pi * radius * radius
    }

    /// Checks if this circle contains a point.
    public func contains(_ point: Vec2) -> Bool {
        center.distanceSquared(to: point) <= radius * radius
    }

    /// Checks if this circle intersects with another circle.
    public func intersects(_ other: Circle) -> Bool {
        let radiusSum = radius + other.radius
        return center.distanceSquared(to: other.center) <= radiusSum * radiusSum
    }

    /// Checks if this circle fully contains another circle.
    public func contains(_ other: Circle) -> Bool {
        let distance = center.distance(to: other.center)
        return distance + other.radius <= radius
    }

    /// Returns the collision result between this circle and another.
    public func collisionResult(with other: Circle) -> CollisionResult {
        let delta = other.center - center
        let distanceSquared = delta.magnitudeSquared
        let radiusSum = radius + other.radius

        guard distanceSquared <= radiusSum * radiusSum else {
            return .noCollision
        }

        let distance = sqrt(distanceSquared)
        let depth = radiusSum - distance

        if distance > 0 {
            let normal = delta / distance
            let contactPoint = center + normal * radius
            return .collision(at: contactPoint, normal: normal, depth: depth)
        } else {
            // Circles are at the same position
            let normal = Vec2(x: 1, y: 0)
            return .collision(at: center, normal: normal, depth: radiusSum)
        }
    }

    /// Checks if this circle intersects with an AABB.
    public func intersects(_ aabb: AABB) -> Bool {
        let closest = aabb.closestPoint(to: center)
        return center.distanceSquared(to: closest) <= radius * radius
    }

    /// Returns the collision result between this circle and an AABB.
    public func collisionResult(with aabb: AABB) -> CollisionResult {
        let closest = aabb.closestPoint(to: center)
        let delta = closest - center
        let distanceSquared = delta.magnitudeSquared

        guard distanceSquared <= radius * radius else {
            return .noCollision
        }

        let distance = sqrt(distanceSquared)

        if distance > 0 {
            let normal = -delta / distance
            let depth = radius - distance
            return .collision(at: closest, normal: normal, depth: depth)
        } else {
            // Circle center is inside AABB
            let toMin = center - aabb.min
            let toMax = aabb.max - center

            let minDist = Swift.min(toMin.x, toMin.y, toMax.x, toMax.y)

            let normal: Vec2
            if minDist == toMin.x {
                normal = Vec2(x: -1, y: 0)
            } else if minDist == toMax.x {
                normal = Vec2(x: 1, y: 0)
            } else if minDist == toMin.y {
                normal = Vec2(x: 0, y: -1)
            } else {
                normal = Vec2(x: 0, y: 1)
            }

            return .collision(at: center, normal: normal, depth: radius + minDist)
        }
    }

    /// Returns the closest point on the circle's edge to the given point.
    public func closestPoint(to point: Vec2) -> Vec2 {
        let direction = (point - center).normalized()
        return center + direction * radius
    }
}
