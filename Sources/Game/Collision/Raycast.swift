import Foundation

/// The result of a raycast operation with detailed hit information.
public struct RaycastHit: Sendable, Hashable {
    /// Whether the ray hit something.
    public let hit: Bool

    /// The distance to the hit point.
    public let distance: Double?

    /// The point where the ray hit.
    public let point: Vec2?

    /// The normal at the hit point.
    public let normal: Vec2?

    public init(
        hit: Bool,
        distance: Double? = nil,
        point: Vec2? = nil,
        normal: Vec2? = nil
    ) {
        self.hit = hit
        self.distance = distance
        self.point = point
        self.normal = normal
    }

    /// A result indicating no hit.
    public static let noHit = RaycastHit(hit: false)

    /// Creates a hit result with full information.
    public static func hit(
        distance: Double,
        point: Vec2,
        normal: Vec2
    ) -> RaycastHit {
        RaycastHit(
            hit: true,
            distance: distance,
            point: point,
            normal: normal
        )
    }
}

/// Performs raycasting operations with detailed hit results.
public enum Raycast {
    /// Casts a ray against a circle and returns detailed hit information.
    public static func cast(
        ray: Ray,
        circle: Circle,
        maxDistance: Double = .infinity
    ) -> RaycastHit {
        guard let distance = ray.cast(circle: circle, maxDistance: maxDistance) else {
            return .noHit
        }

        let hitPoint = ray.point(at: distance)
        let normal = (hitPoint - circle.center).normalized()

        return .hit(distance: distance, point: hitPoint, normal: normal)
    }

    /// Casts a ray against an AABB and returns detailed hit information.
    public static func cast(
        ray: Ray,
        aabb: AABB,
        maxDistance: Double = .infinity
    ) -> RaycastHit {
        guard let distance = ray.cast(aabb: aabb, maxDistance: maxDistance) else {
            return .noHit
        }

        let hitPoint = ray.point(at: distance)

        // Calculate normal based on which face was hit
        let epsilon = 0.0001
        let normal: Vec2

        if abs(hitPoint.x - aabb.min.x) < epsilon {
            normal = Vec2(x: -1, y: 0)
        } else if abs(hitPoint.x - aabb.max.x) < epsilon {
            normal = Vec2(x: 1, y: 0)
        } else if abs(hitPoint.y - aabb.min.y) < epsilon {
            normal = Vec2(x: 0, y: -1)
        } else if abs(hitPoint.y - aabb.max.y) < epsilon {
            normal = Vec2(x: 0, y: 1)
        } else {
            // Default to direction away from center
            normal = (hitPoint - aabb.center).normalized()
        }

        return .hit(distance: distance, point: hitPoint, normal: normal)
    }

    /// Casts a ray and returns the closest hit from multiple circles.
    public static func cast(
        ray: Ray,
        circles: [Circle],
        maxDistance: Double = .infinity
    ) -> RaycastHit {
        var closestHit: RaycastHit = .noHit
        var closestDistance = maxDistance

        for circle in circles {
            let hit = cast(ray: ray, circle: circle, maxDistance: closestDistance)
            if hit.hit, let distance = hit.distance, distance < closestDistance {
                closestHit = hit
                closestDistance = distance
            }
        }

        return closestHit
    }

    /// Casts a ray and returns the closest hit from multiple AABBs.
    public static func cast(
        ray: Ray,
        aabbs: [AABB],
        maxDistance: Double = .infinity
    ) -> RaycastHit {
        var closestHit: RaycastHit = .noHit
        var closestDistance = maxDistance

        for aabb in aabbs {
            let hit = cast(ray: ray, aabb: aabb, maxDistance: closestDistance)
            if hit.hit, let distance = hit.distance, distance < closestDistance {
                closestHit = hit
                closestDistance = distance
            }
        }

        return closestHit
    }
}
