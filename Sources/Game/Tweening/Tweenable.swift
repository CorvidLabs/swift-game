import Foundation

/// A protocol for types that can be tweened (interpolated).
public protocol Tweenable: Sendable {
    /// Linearly interpolates between self and another value.
    func lerp(to other: Self, t: Double) -> Self
}

// MARK: - Built-in Conformances

extension Double: Tweenable {
    public func lerp(to other: Double, t: Double) -> Double {
        Interpolation.lerp(from: self, to: other, t: t)
    }
}

extension Float: Tweenable {
    public func lerp(to other: Float, t: Double) -> Float {
        Float(Interpolation.lerp(from: Double(self), to: Double(other), t: t))
    }
}

extension Vec2: Tweenable {
    // Already has lerp method
}

extension Vec3: Tweenable {
    // Already has lerp method
}

extension Angle: Tweenable {
    // Already has lerp method
}
