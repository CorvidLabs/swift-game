import Foundation

/// A three-dimensional vector for game mathematics.
public struct Vec3: Sendable, Hashable, Codable {
    public let x: Double
    public let y: Double
    public let z: Double

    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// The zero vector (0, 0, 0).
    public static let zero = Vec3(x: 0, y: 0, z: 0)

    /// The unit vector pointing right (1, 0, 0).
    public static let right = Vec3(x: 1, y: 0, z: 0)

    /// The unit vector pointing up (0, 1, 0).
    public static let up = Vec3(x: 0, y: 1, z: 0)

    /// The unit vector pointing forward (0, 0, 1).
    public static let forward = Vec3(x: 0, y: 0, z: 1)

    /// The unit vector pointing left (-1, 0, 0).
    public static let left = Vec3(x: -1, y: 0, z: 0)

    /// The unit vector pointing down (0, -1, 0).
    public static let down = Vec3(x: 0, y: -1, z: 0)

    /// The unit vector pointing back (0, 0, -1).
    public static let back = Vec3(x: 0, y: 0, z: -1)

    /// The vector with all components set to 1 (1, 1, 1).
    public static let one = Vec3(x: 1, y: 1, z: 1)

    /// Returns the magnitude (length) of this vector.
    public var magnitude: Double {
        sqrt(x * x + y * y + z * z)
    }

    /// Returns the squared magnitude of this vector.
    /// Useful for distance comparisons without expensive sqrt.
    public var magnitudeSquared: Double {
        x * x + y * y + z * z
    }

    /// Returns a normalized version of this vector (unit vector).
    public func normalized() -> Vec3 {
        let mag = magnitude
        guard mag > 0 else { return .zero }
        return Vec3(x: x / mag, y: y / mag, z: z / mag)
    }

    /// Computes the dot product with another vector.
    public func dot(_ other: Vec3) -> Double {
        x * other.x + y * other.y + z * other.z
    }

    /// Computes the cross product with another vector.
    public func cross(_ other: Vec3) -> Vec3 {
        Vec3(
            x: y * other.z - z * other.y,
            y: z * other.x - x * other.z,
            z: x * other.y - y * other.x
        )
    }

    /// Calculates the distance to another vector.
    public func distance(to other: Vec3) -> Double {
        (self - other).magnitude
    }

    /// Calculates the squared distance to another vector.
    public func distanceSquared(to other: Vec3) -> Double {
        (self - other).magnitudeSquared
    }

    /// Returns a vector with the absolute values of components.
    public var absolute: Vec3 {
        Vec3(x: abs(x), y: abs(y), z: abs(z))
    }

    /// Returns a vector with each component clamped to the given range.
    public func clamped(min: Vec3, max: Vec3) -> Vec3 {
        Vec3(
            x: Swift.max(min.x, Swift.min(max.x, x)),
            y: Swift.max(min.y, Swift.min(max.y, y)),
            z: Swift.max(min.z, Swift.min(max.z, z))
        )
    }

    /// Reflects this vector across a normal.
    public func reflected(across normal: Vec3) -> Vec3 {
        self - 2 * dot(normal) * normal
    }

    /// Projects this vector onto another vector.
    public func projected(onto other: Vec3) -> Vec3 {
        let dotProduct = dot(other)
        let magnitudeSquared = other.magnitudeSquared
        guard magnitudeSquared > 0 else { return .zero }
        return other * (dotProduct / magnitudeSquared)
    }

    /// Linearly interpolates between this vector and another.
    public func lerp(to other: Vec3, t: Double) -> Vec3 {
        Vec3(
            x: x + (other.x - x) * t,
            y: y + (other.y - y) * t,
            z: z + (other.z - z) * t
        )
    }

    /// Returns the XY components as a Vec2.
    public var xy: Vec2 {
        Vec2(x: x, y: y)
    }

    /// Returns the XZ components as a Vec2.
    public var xz: Vec2 {
        Vec2(x: x, y: z)
    }
}

// MARK: - Operators

extension Vec3 {
    public static func + (lhs: Vec3, rhs: Vec3) -> Vec3 {
        Vec3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func - (lhs: Vec3, rhs: Vec3) -> Vec3 {
        Vec3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    public static func * (lhs: Vec3, rhs: Double) -> Vec3 {
        Vec3(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    public static func * (lhs: Double, rhs: Vec3) -> Vec3 {
        Vec3(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z)
    }

    public static func / (lhs: Vec3, rhs: Double) -> Vec3 {
        Vec3(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    public static prefix func - (vector: Vec3) -> Vec3 {
        Vec3(x: -vector.x, y: -vector.y, z: -vector.z)
    }

    public static func += (lhs: inout Vec3, rhs: Vec3) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Vec3, rhs: Vec3) {
        lhs = lhs - rhs
    }

    public static func *= (lhs: inout Vec3, rhs: Double) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Vec3, rhs: Double) {
        lhs = lhs / rhs
    }
}
