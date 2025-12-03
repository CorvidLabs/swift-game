import Foundation

/// Schedules and manages timed events.
public actor Scheduler {
    /// A scheduled event with its callback.
    public struct ScheduledEvent: Sendable {
        let id: UUID
        let triggerTime: Double
        let action: @Sendable () -> Void
        let repeating: Bool
        let interval: Double

        init(
            id: UUID = UUID(),
            triggerTime: Double,
            action: @escaping @Sendable () -> Void,
            repeating: Bool = false,
            interval: Double = 0
        ) {
            self.id = id
            self.triggerTime = triggerTime
            self.action = action
            self.repeating = repeating
            self.interval = interval
        }
    }

    private var currentTime: Double = 0
    private var events: [ScheduledEvent] = []

    /// Creates a new scheduler.
    public init() {}

    /// Schedules an event to occur after the given delay.
    @discardableResult
    public func scheduleOnce(after delay: Double, action: @escaping @Sendable () -> Void) -> UUID {
        let event = ScheduledEvent(
            triggerTime: currentTime + delay,
            action: action
        )
        events.append(event)
        return event.id
    }

    /// Schedules a repeating event with the given interval.
    @discardableResult
    public func scheduleRepeating(interval: Double, action: @escaping @Sendable () -> Void) -> UUID {
        let event = ScheduledEvent(
            triggerTime: currentTime + interval,
            action: action,
            repeating: true,
            interval: interval
        )
        events.append(event)
        return event.id
    }

    /// Cancels a scheduled event by its ID.
    public func cancel(_ id: UUID) {
        events.removeAll { $0.id == id }
    }

    /// Cancels all scheduled events.
    public func cancelAll() {
        events.removeAll()
    }

    /// Updates the scheduler and triggers events that are ready.
    public func update(deltaTime: Double) {
        currentTime += deltaTime

        var eventsToReschedule: [ScheduledEvent] = []

        events.removeAll { event in
            if currentTime >= event.triggerTime {
                event.action()

                if event.repeating {
                    eventsToReschedule.append(
                        ScheduledEvent(
                            id: event.id,
                            triggerTime: currentTime + event.interval,
                            action: event.action,
                            repeating: true,
                            interval: event.interval
                        )
                    )
                }
                return true
            }
            return false
        }

        events.append(contentsOf: eventsToReschedule)
    }

    /// Returns the number of scheduled events.
    public var eventCount: Int {
        events.count
    }

    /// Resets the scheduler's internal time.
    public func resetTime() {
        currentTime = 0
    }
}
