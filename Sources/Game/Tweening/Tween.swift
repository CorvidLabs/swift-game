import Foundation

/// A single value animation using easing functions.
public struct Tween<Value: Tweenable>: Sendable {
    public let start: Value
    public let end: Value
    public let duration: Double
    public let easing: @Sendable (Double) -> Double

    private var elapsed: Double = 0
    private var isComplete: Bool = false

    /// Creates a tween from a start value to an end value.
    public init(
        from start: Value,
        to end: Value,
        duration: Double,
        easing: @escaping @Sendable (Double) -> Double = Easing.linear
    ) {
        self.start = start
        self.end = end
        self.duration = duration
        self.easing = easing
    }

    /// The current value of the tween.
    public var value: Value {
        let t = min(1.0, elapsed / duration)
        let easedT = easing(t)
        return start.lerp(to: end, t: easedT)
    }

    /// The progress of the tween from 0 to 1.
    public var progress: Double {
        min(1.0, elapsed / duration)
    }

    /// Whether the tween has completed.
    public var completed: Bool {
        isComplete || elapsed >= duration
    }

    /// Updates the tween with the given time delta.
    public mutating func update(deltaTime: Double) {
        guard !isComplete else { return }
        elapsed += deltaTime
        if elapsed >= duration {
            elapsed = duration
            isComplete = true
        }
    }

    /// Resets the tween to the beginning.
    public mutating func reset() {
        elapsed = 0
        isComplete = false
    }

    /// Seeks to a specific time in the tween.
    public mutating func seek(to time: Double) {
        elapsed = max(0, min(duration, time))
        isComplete = elapsed >= duration
    }

    /// Seeks to a specific progress (0 to 1) in the tween.
    public mutating func seekToProgress(_ progress: Double) {
        seek(to: progress * duration)
    }

    /// Creates a reversed version of this tween.
    public func reversed() -> Tween<Value> {
        Tween(from: end, to: start, duration: duration, easing: easing)
    }
}

// MARK: - Preset Tweens

extension Tween {
    /// Creates a tween with quadratic ease-in.
    public static func quadraticIn(
        from start: Value,
        to end: Value,
        duration: Double
    ) -> Tween {
        Tween(from: start, to: end, duration: duration, easing: Easing.quadraticIn)
    }

    /// Creates a tween with quadratic ease-out.
    public static func quadraticOut(
        from start: Value,
        to end: Value,
        duration: Double
    ) -> Tween {
        Tween(from: start, to: end, duration: duration, easing: Easing.quadraticOut)
    }

    /// Creates a tween with quadratic ease-in-out.
    public static func quadraticInOut(
        from start: Value,
        to end: Value,
        duration: Double
    ) -> Tween {
        Tween(from: start, to: end, duration: duration, easing: Easing.quadraticInOut)
    }

    /// Creates a tween with elastic ease-out.
    public static func elasticOut(
        from start: Value,
        to end: Value,
        duration: Double
    ) -> Tween {
        Tween(from: start, to: end, duration: duration, easing: Easing.elasticOut)
    }

    /// Creates a tween with bounce ease-out.
    public static func bounceOut(
        from start: Value,
        to end: Value,
        duration: Double
    ) -> Tween {
        Tween(from: start, to: end, duration: duration, easing: Easing.bounceOut)
    }

    /// Creates a tween with back ease-out (overshoot).
    public static func backOut(
        from start: Value,
        to end: Value,
        duration: Double
    ) -> Tween {
        Tween(from: start, to: end, duration: duration, easing: Easing.backOut)
    }
}
