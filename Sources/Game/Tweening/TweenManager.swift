import Foundation

/// Protocol for type-erased managed tweens.
private protocol AnyManagedTween: AnyObject {
    var id: UUID { get }
    var onComplete: (@Sendable () -> Void)? { get }
    func update(deltaTime: Double) -> Bool
}

/// Manages multiple tweens and their lifecycle.
public final class TweenManager: @unchecked Sendable {
    /// A managed tween with an identifier and completion callback.
    private final class ManagedTweenBox<Value: Tweenable>: AnyManagedTween, @unchecked Sendable {
        let id: UUID
        var tween: Tween<Value>
        let onUpdate: @Sendable (Value) -> Void
        let onComplete: (@Sendable () -> Void)?

        init(
            id: UUID,
            tween: Tween<Value>,
            onUpdate: @escaping @Sendable (Value) -> Void,
            onComplete: (@Sendable () -> Void)? = nil
        ) {
            self.id = id
            self.tween = tween
            self.onUpdate = onUpdate
            self.onComplete = onComplete
        }

        func update(deltaTime: Double) -> Bool {
            tween.update(deltaTime: deltaTime)
            onUpdate(tween.value)
            return tween.completed
        }
    }

    private var tweens: [any AnyManagedTween] = []

    /// Creates a new tween manager.
    public init() {}

    /// Adds a tween to be managed.
    /// - Parameters:
    ///   - tween: The tween to manage.
    ///   - onUpdate: Called each frame with the current value.
    ///   - onComplete: Called when the tween completes.
    @discardableResult
    public func add<Value: Tweenable>(
        _ tween: Tween<Value>,
        onUpdate: @escaping @Sendable (Value) -> Void,
        onComplete: (@Sendable () -> Void)? = nil
    ) -> UUID {
        let id = UUID()
        let box = ManagedTweenBox(
            id: id,
            tween: tween,
            onUpdate: onUpdate,
            onComplete: onComplete
        )
        tweens.append(box)
        return id
    }

    /// Adds a simple tween without manual creation.
    @discardableResult
    public func tween<Value: Tweenable>(
        from start: Value,
        to end: Value,
        duration: Double,
        easing: @escaping @Sendable (Double) -> Double = Easing.linear,
        onUpdate: @escaping @Sendable (Value) -> Void,
        onComplete: (@Sendable () -> Void)? = nil
    ) -> UUID {
        let tween = Tween(from: start, to: end, duration: duration, easing: easing)
        return add(tween, onUpdate: onUpdate, onComplete: onComplete)
    }

    /// Cancels a tween by its ID.
    public func cancel(_ id: UUID) {
        tweens.removeAll { $0.id == id }
    }

    /// Cancels all active tweens.
    public func cancelAll() {
        tweens.removeAll()
    }

    /// Updates all active tweens.
    public func update(deltaTime: Double) {
        var completedTweens: [any AnyManagedTween] = []

        tweens.removeAll { tween in
            let completed = tween.update(deltaTime: deltaTime)
            if completed {
                completedTweens.append(tween)
            }
            return completed
        }

        for tween in completedTweens {
            tween.onComplete?()
        }
    }

    /// The number of active tweens.
    public var activeTweenCount: Int {
        tweens.count
    }

    /// Whether there are any active tweens.
    public var hasActiveTweens: Bool {
        !tweens.isEmpty
    }
}

// MARK: - Convenience Extensions

extension TweenManager {
    /// Tweens a Double value.
    @discardableResult
    public func tweenDouble(
        from start: Double,
        to end: Double,
        duration: Double,
        easing: @escaping @Sendable (Double) -> Double = Easing.linear,
        onUpdate: @escaping @Sendable (Double) -> Void,
        onComplete: (@Sendable () -> Void)? = nil
    ) -> UUID {
        tween(from: start, to: end, duration: duration, easing: easing, onUpdate: onUpdate, onComplete: onComplete)
    }

    /// Tweens a Vec2 value.
    @discardableResult
    public func tweenVec2(
        from start: Vec2,
        to end: Vec2,
        duration: Double,
        easing: @escaping @Sendable (Double) -> Double = Easing.linear,
        onUpdate: @escaping @Sendable (Vec2) -> Void,
        onComplete: (@Sendable () -> Void)? = nil
    ) -> UUID {
        tween(from: start, to: end, duration: duration, easing: easing, onUpdate: onUpdate, onComplete: onComplete)
    }

    /// Tweens an Angle value.
    @discardableResult
    public func tweenAngle(
        from start: Angle,
        to end: Angle,
        duration: Double,
        easing: @escaping @Sendable (Double) -> Double = Easing.linear,
        onUpdate: @escaping @Sendable (Angle) -> Void,
        onComplete: (@Sendable () -> Void)? = nil
    ) -> UUID {
        tween(from: start, to: end, duration: duration, easing: easing, onUpdate: onUpdate, onComplete: onComplete)
    }
}
