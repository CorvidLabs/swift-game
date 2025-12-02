import Foundation

/// A generic finite state machine with support for state transitions and callbacks.
public final class StateMachine<StateType: Hashable & Sendable>: @unchecked Sendable {
    /// A callback that can be registered for state transitions.
    public struct TransitionCallback: Sendable {
        private let action: @Sendable (StateType, StateType) -> Void

        public init(_ action: @escaping @Sendable (StateType, StateType) -> Void) {
            self.action = action
        }

        func call(from: StateType, to: StateType) {
            action(from, to)
        }
    }

    private var currentState: StateType
    private var states: [StateType: any State] = [:]
    private var onTransitionCallbacks: [TransitionCallback] = []

    /// The current state of the state machine.
    public var current: StateType {
        currentState
    }

    /// Creates a state machine with an initial state.
    public init(initialState: StateType) {
        self.currentState = initialState
    }

    /// Registers a state with its handler.
    public func register(state: StateType, handler: any State) {
        states[state] = handler
    }

    /// Registers multiple states at once.
    public func register(states: [StateType: any State]) {
        for (state, handler) in states {
            register(state: state, handler: handler)
        }
    }

    /// Transitions to a new state.
    public func transition(to newState: StateType) {
        guard newState != currentState else { return }

        let previousState = currentState
        states[currentState]?.onExit()

        currentState = newState
        states[currentState]?.onEnter()

        for callback in onTransitionCallbacks {
            callback.call(from: previousState, to: newState)
        }
    }

    /// Updates the current state.
    public func update(deltaTime: Double) {
        states[currentState]?.onUpdate(deltaTime: deltaTime)
    }

    /// Registers a callback to be called on any state transition.
    public func onTransition(_ callback: @escaping @Sendable (StateType, StateType) -> Void) {
        onTransitionCallbacks.append(TransitionCallback(callback))
    }

    /// Checks if the state machine is in a specific state.
    public func isInState(_ state: StateType) -> Bool {
        currentState == state
    }

    /// Checks if the state machine is in any of the given states.
    public func isInAnyState(_ states: [StateType]) -> Bool {
        states.contains(currentState)
    }
}
