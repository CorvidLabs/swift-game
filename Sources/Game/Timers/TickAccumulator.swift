import Foundation

/**
 Accumulates time for fixed timestep updates.
 Useful for physics simulation and other fixed-rate logic.
 */
public struct TickAccumulator: Sendable {
    public let fixedDeltaTime: Double
    private var accumulator: Double

    /// Creates a tick accumulator with the given fixed timestep.
    public init(fixedDeltaTime: Double) {
        self.fixedDeltaTime = fixedDeltaTime
        self.accumulator = 0
    }

    /// Creates a tick accumulator with a target frequency (ticks per second).
    public static func withFrequency(_ frequency: Double) -> TickAccumulator {
        TickAccumulator(fixedDeltaTime: 1.0 / frequency)
    }

    /// The number of ticks that should be processed this frame.
    public var tickCount: Int {
        Int(accumulator / fixedDeltaTime)
    }

    /**
     The interpolation factor for smooth rendering between ticks.
     Value between 0 and 1 representing partial progress to the next tick.
     */
    public var alpha: Double {
        accumulator / fixedDeltaTime - Double(tickCount)
    }

    /**
     Adds frame time to the accumulator.
     Returns the number of ticks that should be processed.
     */
    @discardableResult
    public mutating func add(deltaTime: Double) -> Int {
        accumulator += deltaTime
        let ticks = tickCount
        accumulator -= Double(ticks) * fixedDeltaTime
        return ticks
    }

    /// Processes accumulated time with a fixed timestep update callback.
    public mutating func update(
        deltaTime: Double,
        fixedUpdate: @Sendable (Double) -> Void
    ) {
        accumulator += deltaTime

        while accumulator >= fixedDeltaTime {
            fixedUpdate(fixedDeltaTime)
            accumulator -= fixedDeltaTime
        }
    }

    /// Resets the accumulator to zero.
    public mutating func reset() {
        accumulator = 0
    }

    /// The current accumulated time.
    public var currentAccumulator: Double {
        accumulator
    }
}
