import Foundation

/// Manages cooldowns for actions with timing constraints.
public struct Cooldown: Sendable {
    public let duration: Double
    private var remainingTime: Double

    /// Creates a cooldown with the given duration.
    public init(duration: Double) {
        self.duration = duration
        self.remainingTime = 0
    }

    /// Whether the cooldown is ready (has finished).
    public var isReady: Bool {
        remainingTime <= 0
    }

    /// The remaining time until the cooldown is ready.
    public var remaining: Double {
        max(0, remainingTime)
    }

    /// The progress of the cooldown (0 = ready, 1 = just triggered).
    public var progress: Double {
        guard duration > 0 else { return 1 }
        return 1 - (remaining / duration)
    }

    /// Updates the cooldown with the given time delta.
    public mutating func update(deltaTime: Double) {
        if remainingTime > 0 {
            remainingTime -= deltaTime
        }
    }

    /// Triggers the cooldown, starting the timer.
    public mutating func trigger() {
        remainingTime = duration
    }

    /// Resets the cooldown to the ready state.
    public mutating func reset() {
        remainingTime = 0
    }

    /// Attempts to trigger the cooldown if it's ready.
    /// Returns true if successful, false if still on cooldown.
    @discardableResult
    public mutating func tryTrigger() -> Bool {
        guard isReady else { return false }
        trigger()
        return true
    }

    /// Sets the remaining time directly.
    public mutating func setRemaining(_ time: Double) {
        remainingTime = max(0, time)
    }
}
