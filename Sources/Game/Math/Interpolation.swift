import Foundation

/// Interpolation functions for smooth transitions and value mapping.
public enum Interpolation {
    /// Linear interpolation between two values.
    public static func lerp(from start: Double, to end: Double, t: Double) -> Double {
        start + (end - start) * t
    }

    /// Inverse linear interpolation - finds t for a value between start and end.
    public static func inverseLerp(from start: Double, to end: Double, value: Double) -> Double {
        guard start != end else { return 0 }
        return (value - start) / (end - start)
    }

    /// Remaps a value from one range to another.
    public static func remap(
        value: Double,
        fromRange: ClosedRange<Double>,
        toRange: ClosedRange<Double>
    ) -> Double {
        let t = inverseLerp(
            from: fromRange.lowerBound,
            to: fromRange.upperBound,
            value: value
        )
        return lerp(
            from: toRange.lowerBound,
            to: toRange.upperBound,
            t: t
        )
    }

    /// Smoothstep interpolation - smooth ease in/out using cubic Hermite.
    public static func smoothstep(_ t: Double) -> Double {
        let clamped = Swift.max(0, Swift.min(1, t))
        return clamped * clamped * (3 - 2 * clamped)
    }

    /// Smoother step interpolation - even smoother than smoothstep using quintic.
    public static func smootherstep(_ t: Double) -> Double {
        let clamped = Swift.max(0, Swift.min(1, t))
        return clamped * clamped * clamped * (clamped * (clamped * 6 - 15) + 10)
    }

    /// Smoothstep between two values.
    public static func smoothstep(from start: Double, to end: Double, t: Double) -> Double {
        lerp(from: start, to: end, t: smoothstep(t))
    }

    /// Smoother step between two values.
    public static func smootherstep(from start: Double, to end: Double, t: Double) -> Double {
        lerp(from: start, to: end, t: smootherstep(t))
    }

    /// Clamps a value to the specified range.
    public static func clamp(_ value: Double, min: Double, max: Double) -> Double {
        Swift.max(min, Swift.min(max, value))
    }

    /// Clamps a value to the range [0, 1].
    public static func clamp01(_ value: Double) -> Double {
        clamp(value, min: 0, max: 1)
    }

    /// Moves current towards target by a maximum delta.
    public static func moveTowards(
        current: Double,
        target: Double,
        maxDelta: Double
    ) -> Double {
        let delta = target - current
        if abs(delta) <= maxDelta {
            return target
        }
        return current + maxDelta * (delta > 0 ? 1 : -1)
    }

    /// Exponential decay interpolation for smooth damping.
    public static func exponentialDecay(
        current: Double,
        target: Double,
        decay: Double,
        deltaTime: Double
    ) -> Double {
        lerp(from: current, to: target, t: 1 - exp(-decay * deltaTime))
    }

    /// Spring interpolation for bouncy motion.
    public static func spring(
        current: Double,
        target: Double,
        velocity: inout Double,
        stiffness: Double = 100,
        damping: Double = 10,
        deltaTime: Double
    ) -> Double {
        let force = (target - current) * stiffness
        let dampingForce = velocity * damping
        let acceleration = force - dampingForce
        velocity += acceleration * deltaTime
        return current + velocity * deltaTime
    }

    /// Ping-pong a value between 0 and length.
    public static func pingPong(_ value: Double, length: Double) -> Double {
        guard length > 0 else { return 0 }
        let normalized = value.truncatingRemainder(dividingBy: length * 2)
        if normalized < length {
            return normalized
        }
        return length * 2 - normalized
    }

    /// Repeats a value within the range [0, length).
    public static func `repeat`(_ value: Double, length: Double) -> Double {
        guard length > 0 else { return 0 }
        return value - floor(value / length) * length
    }
}
