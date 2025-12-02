import Foundation

/// A protocol representing a state in a finite state machine.
public protocol State: Sendable {
    /// Called when entering this state.
    func onEnter()

    /// Called every update while in this state.
    func onUpdate(deltaTime: Double)

    /// Called when exiting this state.
    func onExit()
}

/// Default implementations for optional state callbacks.
extension State {
    public func onEnter() {}
    public func onUpdate(deltaTime: Double) {}
    public func onExit() {}
}
