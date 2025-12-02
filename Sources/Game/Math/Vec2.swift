import Foundation

/// A two-dimensional vector for game mathematics.
public struct Vec2: Sendable, Hashable, Codable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    /// The zero vector (0, 0).
    public static let zero = Vec2(x: 0, y: 0)

    /// The unit vector pointing right (1, 0).
    public static let right = Vec2(x: 1, y: 0)

    /// The unit vector pointing up (0, 1).
    public static let up = Vec2(x: 0, y: 1)

    /// The unit vector pointing left (-1, 0).
    public static let left = Vec2(x: -1, y: 0)

    /// The unit vector pointing down (0, -1).
    public static let down = Vec2(x: 0, y: -1)

    /// The vector with both components set to 1 (1, 1).
    public static let one = Vec2(x: 1, y: 1)

    /// Returns the magnitude (length) of this vector.
    public var magnitude: Double {
        sqrt(x * x + y * y)
    }

    /// Returns the squared magnitude of this vector.
    /// Useful for distance comparisons without expensive sqrt.
    public var magnitudeSquared: Double {
        x * x + y * y
    }

    /// Returns a normalized version of this vector (unit vector).
    public func normalized() -> Vec2 {
        let mag = magnitude
        guard mag > 0 else { return .zero }
        return Vec2(x: x / mag, y: y / mag)
    }

    /// Computes the dot product with another vector.
    public func dot(_ other: Vec2) -> Double {
        x * other.x + y * other.y
    }

    /// Computes the 2D cross product (returns scalar z-component).
    public func cross(_ other: Vec2) -> Double {
        x * other.y - y * other.x
    }

    /// Calculates the distance to another vector.
    public func distance(to other: Vec2) -> Double {
        (self - other).magnitude
    }

    /// Calculates the squared distance to another vector.
    public func distanceSquared(to other: Vec2) -> Double {
        (self - other).magnitudeSquared
    }

    /// Returns the angle of this vector in radians.
    public var angle: Double {
        atan2(y, x)
    }

    /// Returns a vector perpendicular to this one (rotated 90 degrees counterclockwise).
    public var perpendicular: Vec2 {
        Vec2(x: -y, y: x)
    }

    /// Returns this vector rotated by the given angle in radians.
    public func rotated(by radians: Double) -> Vec2 {
        let cos = Foundation.cos(radians)
        let sin = Foundation.sin(radians)
        return Vec2(
            x: x * cos - y * sin,
            y: x * sin + y * cos
        )
    }

    /// Returns a vector with the absolute values of components.
    public var absolute: Vec2 {
        Vec2(x: abs(x), y: abs(y))
    }

    /// Returns a vector with each component clamped to the given range.
    public func clamped(min: Vec2, max: Vec2) -> Vec2 {
        Vec2(
            x: Swift.max(min.x, Swift.min(max.x, x)),
            y: Swift.max(min.y, Swift.min(max.y, y))
        )
    }

    /// Creates a vector from an angle and magnitude.
    public static func fromAngle(_ radians: Double, magnitude: Double = 1.0) -> Vec2 {
        Vec2(
            x: cos(radians) * magnitude,
            y: sin(radians) * magnitude
        )
    }

    /// Reflects this vector across a normal.
    public func reflected(across normal: Vec2) -> Vec2 {
        self - 2 * dot(normal) * normal
    }

    /// Projects this vector onto another vector.
    public func projected(onto other: Vec2) -> Vec2 {
        let dotProduct = dot(other)
        let magnitudeSquared = other.magnitudeSquared
        guard magnitudeSquared > 0 else { return .zero }
        return other * (dotProduct / magnitudeSquared)
    }

    /// Linearly interpolates between this vector and another.
    public func lerp(to other: Vec2, t: Double) -> Vec2 {
        Vec2(
            x: x + (other.x - x) * t,
            y: y + (other.y - y) * t
        )
    }
}

// MARK: - Operators

extension Vec2 {
    public static func + (lhs: Vec2, rhs: Vec2) -> Vec2 {
        Vec2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: Vec2, rhs: Vec2) -> Vec2 {
        Vec2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func * (lhs: Vec2, rhs: Double) -> Vec2 {
        Vec2(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    public static func * (lhs: Double, rhs: Vec2) -> Vec2 {
        Vec2(x: lhs * rhs.x, y: lhs * rhs.y)
    }

    public static func / (lhs: Vec2, rhs: Double) -> Vec2 {
        Vec2(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    public static prefix func - (vector: Vec2) -> Vec2 {
        Vec2(x: -vector.x, y: -vector.y)
    }

    public static func += (lhs: inout Vec2, rhs: Vec2) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Vec2, rhs: Vec2) {
        lhs = lhs - rhs
    }

    public static func *= (lhs: inout Vec2, rhs: Double) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Vec2, rhs: Double) {
        lhs = lhs / rhs
    }
}
