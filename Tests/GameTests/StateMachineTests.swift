import Testing
@testable import Game

@Suite("State Machine Tests")
struct StateMachineTests {
    enum GameState: Hashable, Sendable {
        case idle
        case running
        case paused
        case gameOver
    }

    final class TestState: State, @unchecked Sendable {
        var enterCount = 0
        var updateCount = 0
        var exitCount = 0
        var totalDeltaTime: Double = 0

        func onEnter() {
            enterCount += 1
        }

        func onUpdate(deltaTime: Double) {
            updateCount += 1
            totalDeltaTime += deltaTime
        }

        func onExit() {
            exitCount += 1
        }

        func reset() {
            enterCount = 0
            updateCount = 0
            exitCount = 0
            totalDeltaTime = 0
        }
    }

    @Test("StateMachine initialization")
    func stateMachineInitialization() {
        let sm = StateMachine<GameState>(initialState: .idle)
        #expect(sm.current == .idle)
    }

    @Test("StateMachine state registration")
    func stateMachineStateRegistration() {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()
        let runningState = TestState()

        sm.register(state: .idle, handler: idleState)
        sm.register(state: .running, handler: runningState)

        #expect(sm.current == .idle)
    }

    @Test("StateMachine transitions")
    func stateMachineTransitions() {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()
        let runningState = TestState()

        sm.register(state: .idle, handler: idleState)
        sm.register(state: .running, handler: runningState)

        sm.transition(to: .running)

        #expect(sm.current == .running)
        #expect(idleState.exitCount == 1)
        #expect(runningState.enterCount == 1)
    }

    @Test("StateMachine same state transition")
    func stateMachineSameStateTransition() {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()

        sm.register(state: .idle, handler: idleState)

        sm.transition(to: .idle)

        #expect(idleState.exitCount == 0)
        #expect(idleState.enterCount == 0)
    }

    @Test("StateMachine update")
    func stateMachineUpdate() {
        let sm = StateMachine<GameState>(initialState: .running)
        let runningState = TestState()

        sm.register(state: .running, handler: runningState)

        sm.update(deltaTime: 0.016)
        sm.update(deltaTime: 0.016)

        #expect(runningState.updateCount == 2)
        #expect(abs(runningState.totalDeltaTime - 0.032) < 0.0001)
    }

    @Test("StateMachine transition callbacks")
    func stateMachineTransitionCallbacks() {
        final class CallbackTracker: @unchecked Sendable {
            var callbackFired = false
            var fromState: GameState?
            var toState: GameState?
        }

        let sm = StateMachine<GameState>(initialState: .idle)
        let tracker = CallbackTracker()

        sm.onTransition { from, to in
            tracker.callbackFired = true
            tracker.fromState = from
            tracker.toState = to
        }

        sm.transition(to: .running)

        #expect(tracker.callbackFired)
        #expect(tracker.fromState == .idle)
        #expect(tracker.toState == .running)
    }

    @Test("StateMachine multiple callbacks")
    func stateMachineMultipleCallbacks() {
        final class CallbackTracker: @unchecked Sendable {
            var callback1Fired = false
            var callback2Fired = false
        }

        let sm = StateMachine<GameState>(initialState: .idle)
        let tracker = CallbackTracker()

        sm.onTransition { _, _ in
            tracker.callback1Fired = true
        }

        sm.onTransition { _, _ in
            tracker.callback2Fired = true
        }

        sm.transition(to: .running)

        #expect(tracker.callback1Fired)
        #expect(tracker.callback2Fired)
    }

    @Test("StateMachine state queries")
    func stateMachineStateQueries() {
        let sm = StateMachine<GameState>(initialState: .idle)

        #expect(sm.isInState(.idle))
        #expect(!sm.isInState(.running))

        #expect(sm.isInAnyState([.idle, .paused]))
        #expect(!sm.isInAnyState([.running, .gameOver]))

        sm.transition(to: .running)

        #expect(sm.isInState(.running))
        #expect(sm.isInAnyState([.running, .paused]))
    }

    @Test("StateMachine complex flow")
    func stateMachineComplexFlow() {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()
        let runningState = TestState()
        let pausedState = TestState()

        sm.register(states: [
            .idle: idleState,
            .running: runningState,
            .paused: pausedState
        ])

        sm.transition(to: .running)
        sm.update(deltaTime: 0.016)

        sm.transition(to: .paused)
        sm.update(deltaTime: 0.016)

        sm.transition(to: .running)
        sm.update(deltaTime: 0.016)

        #expect(idleState.enterCount == 0)
        #expect(idleState.exitCount == 1)

        #expect(runningState.enterCount == 2)
        #expect(runningState.exitCount == 1)
        #expect(runningState.updateCount == 2)

        #expect(pausedState.enterCount == 1)
        #expect(pausedState.exitCount == 1)
        #expect(pausedState.updateCount == 1)
    }
}
