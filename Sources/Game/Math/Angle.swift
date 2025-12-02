import Foundation

/// Represents an angle with conversions between degrees and radians.
public struct Angle: Sendable, Hashable, Codable {
    public let radians: Double

    private init(radians: Double) {
        self.radians = radians
    }

    /// Creates an angle from radians.
    public static func radians(_ value: Double) -> Angle {
        Angle(radians: value)
    }

    /// Creates an angle from degrees.
    public static func degrees(_ value: Double) -> Angle {
        Angle(radians: value * .pi / 180.0)
    }

    /// The angle value in degrees.
    public var degrees: Double {
        radians * 180.0 / .pi
    }

    /// Zero angle (0 radians).
    public static let zero = Angle(radians: 0)

    /// Quarter turn (π/2 radians, 90 degrees).
    public static let quarter = Angle(radians: .pi / 2)

    /// Half turn (π radians, 180 degrees).
    public static let half = Angle(radians: .pi)

    /// Three-quarter turn (3π/2 radians, 270 degrees).
    public static let threeQuarters = Angle(radians: 3 * .pi / 2)

    /// Full turn (2π radians, 360 degrees).
    public static let full = Angle(radians: 2 * .pi)

    /// Normalizes the angle to the range [0, 2π).
    public func normalized() -> Angle {
        var value = radians.truncatingRemainder(dividingBy: 2 * .pi)
        if value < 0 {
            value += 2 * .pi
        }
        return Angle(radians: value)
    }

    /// Normalizes the angle to the range [-π, π).
    public func normalizedSigned() -> Angle {
        var value = radians.truncatingRemainder(dividingBy: 2 * .pi)
        if value > .pi {
            value -= 2 * .pi
        } else if value < -.pi {
            value += 2 * .pi
        }
        return Angle(radians: value)
    }

    /// Returns the shortest angular difference to another angle.
    public func difference(to other: Angle) -> Angle {
        let diff = (other.radians - radians).truncatingRemainder(dividingBy: 2 * .pi)
        if diff > .pi {
            return Angle(radians: diff - 2 * .pi)
        } else if diff < -.pi {
            return Angle(radians: diff + 2 * .pi)
        }
        return Angle(radians: diff)
    }

    /// Linearly interpolates between this angle and another.
    public func lerp(to other: Angle, t: Double) -> Angle {
        let diff = difference(to: other)
        return Angle(radians: radians + diff.radians * t)
    }
}

// MARK: - Operators

extension Angle {
    public static func + (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians + rhs.radians)
    }

    public static func - (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians - rhs.radians)
    }

    public static func * (lhs: Angle, rhs: Double) -> Angle {
        Angle(radians: lhs.radians * rhs)
    }

    public static func * (lhs: Double, rhs: Angle) -> Angle {
        Angle(radians: lhs * rhs.radians)
    }

    public static func / (lhs: Angle, rhs: Double) -> Angle {
        Angle(radians: lhs.radians / rhs)
    }

    public static prefix func - (angle: Angle) -> Angle {
        Angle(radians: -angle.radians)
    }

    public static func += (lhs: inout Angle, rhs: Angle) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Angle, rhs: Angle) {
        lhs = lhs - rhs
    }

    public static func *= (lhs: inout Angle, rhs: Double) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Angle, rhs: Double) {
        lhs = lhs / rhs
    }
}

// MARK: - Comparable

extension Angle: Comparable {
    public static func < (lhs: Angle, rhs: Angle) -> Bool {
        lhs.radians < rhs.radians
    }
}
