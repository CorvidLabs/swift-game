import Testing
@testable import Game

@Suite("Timer Tests")
struct TimerTests {
    // MARK: - Cooldown Tests

    @Test("Cooldown initialization")
    func cooldownInitialization() {
        let cooldown = Cooldown(duration: 1.0)

        #expect(cooldown.duration == 1.0)
        #expect(cooldown.isReady)
        #expect(cooldown.remaining == 0)
    }

    @Test("Cooldown trigger")
    func cooldownTrigger() {
        var cooldown = Cooldown(duration: 1.0)

        cooldown.trigger()

        #expect(!cooldown.isReady)
        #expect(cooldown.remaining == 1.0)
    }

    @Test("Cooldown update")
    func cooldownUpdate() {
        var cooldown = Cooldown(duration: 1.0)

        cooldown.trigger()
        cooldown.update(deltaTime: 0.5)

        #expect(!cooldown.isReady)
        #expect(abs(cooldown.remaining - 0.5) < 0.0001)

        cooldown.update(deltaTime: 0.5)

        #expect(cooldown.isReady)
        #expect(cooldown.remaining == 0)
    }

    @Test("Cooldown progress")
    func cooldownProgress() {
        var cooldown = Cooldown(duration: 1.0)

        #expect(cooldown.progress == 1.0)

        cooldown.trigger()
        #expect(cooldown.progress == 0.0)

        cooldown.update(deltaTime: 0.5)
        #expect(abs(cooldown.progress - 0.5) < 0.0001)

        cooldown.update(deltaTime: 0.5)
        #expect(cooldown.progress == 1.0)
    }

    @Test("Cooldown try trigger")
    func cooldownTryTrigger() {
        var cooldown = Cooldown(duration: 1.0)

        let firstTrigger = cooldown.tryTrigger()
        #expect(firstTrigger)
        #expect(!cooldown.isReady)

        let secondTrigger = cooldown.tryTrigger()
        #expect(!secondTrigger)

        cooldown.update(deltaTime: 1.0)
        let thirdTrigger = cooldown.tryTrigger()
        #expect(thirdTrigger)
    }

    @Test("Cooldown reset")
    func cooldownReset() {
        var cooldown = Cooldown(duration: 1.0)

        cooldown.trigger()
        cooldown.update(deltaTime: 0.5)

        cooldown.reset()

        #expect(cooldown.isReady)
        #expect(cooldown.remaining == 0)
    }

    @Test("Cooldown set remaining")
    func cooldownSetRemaining() {
        var cooldown = Cooldown(duration: 2.0)

        cooldown.setRemaining(1.5)

        #expect(!cooldown.isReady)
        #expect(cooldown.remaining == 1.5)

        cooldown.setRemaining(-1.0)
        #expect(cooldown.remaining == 0)
    }

    @Test("Cooldown over-update")
    func cooldownOverUpdate() {
        var cooldown = Cooldown(duration: 1.0)

        cooldown.trigger()
        cooldown.update(deltaTime: 2.0)

        #expect(cooldown.isReady)
        #expect(cooldown.remaining == 0)

        // Further updates should not change state
        cooldown.update(deltaTime: 1.0)
        #expect(cooldown.isReady)
    }

    @Test("Cooldown multiple cycles")
    func cooldownMultipleCycles() {
        var cooldown = Cooldown(duration: 0.5)

        // First cycle
        cooldown.trigger()
        cooldown.update(deltaTime: 0.5)
        #expect(cooldown.isReady)

        // Second cycle
        cooldown.trigger()
        #expect(!cooldown.isReady)
        cooldown.update(deltaTime: 0.5)
        #expect(cooldown.isReady)
    }

    @Test("Cooldown zero duration")
    func cooldownZeroDuration() {
        var cooldown = Cooldown(duration: 0.0)

        #expect(cooldown.progress == 1.0)

        cooldown.trigger()
        #expect(cooldown.isReady)
    }
}
