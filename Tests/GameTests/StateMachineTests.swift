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
    func stateMachineInitialization() async {
        let sm = StateMachine<GameState>(initialState: .idle)
        let current = await sm.current
        #expect(current == .idle)
    }

    @Test("StateMachine state registration")
    func stateMachineStateRegistration() async {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()
        let runningState = TestState()

        await sm.register(state: .idle, handler: idleState)
        await sm.register(state: .running, handler: runningState)

        let current = await sm.current
        #expect(current == .idle)
    }

    @Test("StateMachine transitions")
    func stateMachineTransitions() async {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()
        let runningState = TestState()

        await sm.register(state: .idle, handler: idleState)
        await sm.register(state: .running, handler: runningState)

        await sm.transition(to: .running)

        let current = await sm.current
        #expect(current == .running)
        #expect(idleState.exitCount == 1)
        #expect(runningState.enterCount == 1)
    }

    @Test("StateMachine same state transition")
    func stateMachineSameStateTransition() async {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()

        await sm.register(state: .idle, handler: idleState)

        await sm.transition(to: .idle)

        #expect(idleState.exitCount == 0)
        #expect(idleState.enterCount == 0)
    }

    @Test("StateMachine update")
    func stateMachineUpdate() async {
        let sm = StateMachine<GameState>(initialState: .running)
        let runningState = TestState()

        await sm.register(state: .running, handler: runningState)

        await sm.update(deltaTime: 0.016)
        await sm.update(deltaTime: 0.016)

        #expect(runningState.updateCount == 2)
        #expect(abs(runningState.totalDeltaTime - 0.032) < 0.0001)
    }

    @Test("StateMachine transition callbacks")
    func stateMachineTransitionCallbacks() async {
        final class CallbackTracker: @unchecked Sendable {
            var callbackFired = false
            var fromState: GameState?
            var toState: GameState?
        }

        let sm = StateMachine<GameState>(initialState: .idle)
        let tracker = CallbackTracker()

        await sm.onTransition { from, to in
            tracker.callbackFired = true
            tracker.fromState = from
            tracker.toState = to
        }

        await sm.transition(to: .running)

        #expect(tracker.callbackFired)
        #expect(tracker.fromState == .idle)
        #expect(tracker.toState == .running)
    }

    @Test("StateMachine multiple callbacks")
    func stateMachineMultipleCallbacks() async {
        final class CallbackTracker: @unchecked Sendable {
            var callback1Fired = false
            var callback2Fired = false
        }

        let sm = StateMachine<GameState>(initialState: .idle)
        let tracker = CallbackTracker()

        await sm.onTransition { _, _ in
            tracker.callback1Fired = true
        }

        await sm.onTransition { _, _ in
            tracker.callback2Fired = true
        }

        await sm.transition(to: .running)

        #expect(tracker.callback1Fired)
        #expect(tracker.callback2Fired)
    }

    @Test("StateMachine state queries")
    func stateMachineStateQueries() async {
        let sm = StateMachine<GameState>(initialState: .idle)

        let isIdle = await sm.isInState(.idle)
        var isRunning = await sm.isInState(.running)
        #expect(isIdle)
        #expect(!isRunning)

        let isInIdleOrPaused = await sm.isInAnyState([.idle, .paused])
        let isInRunningOrGameOver = await sm.isInAnyState([.running, .gameOver])
        #expect(isInIdleOrPaused)
        #expect(!isInRunningOrGameOver)

        await sm.transition(to: .running)

        isRunning = await sm.isInState(.running)
        let isInRunningOrPaused = await sm.isInAnyState([.running, .paused])
        #expect(isRunning)
        #expect(isInRunningOrPaused)
    }

    @Test("StateMachine complex flow")
    func stateMachineComplexFlow() async {
        let sm = StateMachine<GameState>(initialState: .idle)
        let idleState = TestState()
        let runningState = TestState()
        let pausedState = TestState()

        await sm.register(states: [
            .idle: idleState,
            .running: runningState,
            .paused: pausedState
        ])

        await sm.transition(to: .running)
        await sm.update(deltaTime: 0.016)

        await sm.transition(to: .paused)
        await sm.update(deltaTime: 0.016)

        await sm.transition(to: .running)
        await sm.update(deltaTime: 0.016)

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
