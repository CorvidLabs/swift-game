import Testing
@testable import Game

@Suite("Tweening Tests")
struct TweeningTests {
    // MARK: - Tweenable Protocol Tests

    @Test("Double tweenable")
    func doubleTweenable() {
        let start: Double = 0.0
        let end: Double = 10.0

        #expect(start.lerp(to: end, t: 0) == 0)
        #expect(start.lerp(to: end, t: 1) == 10)
        #expect(start.lerp(to: end, t: 0.5) == 5)
    }

    @Test("Float tweenable")
    func floatTweenable() {
        let start: Float = 0.0
        let end: Float = 10.0

        #expect(start.lerp(to: end, t: 0) == 0)
        #expect(start.lerp(to: end, t: 1) == 10)
        #expect(abs(start.lerp(to: end, t: 0.5) - 5) < 0.001)
    }

    @Test("Vec2 tweenable")
    func vec2Tweenable() {
        let start = Vec2(x: 0, y: 0)
        let end = Vec2(x: 10, y: 10)

        #expect(start.lerp(to: end, t: 0) == start)
        #expect(start.lerp(to: end, t: 1) == end)
        #expect(start.lerp(to: end, t: 0.5) == Vec2(x: 5, y: 5))
    }

    // MARK: - Tween Tests

    @Test("Tween creation")
    func tweenCreation() {
        let tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        #expect(tween.start == 0.0)
        #expect(tween.end == 10.0)
        #expect(tween.duration == 1.0)
        #expect(!tween.completed)
    }

    @Test("Tween initial value")
    func tweenInitialValue() {
        let tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        #expect(tween.value == 0.0)
        #expect(tween.progress == 0.0)
    }

    @Test("Tween update")
    func tweenUpdate() {
        var tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        tween.update(deltaTime: 0.5)

        #expect(tween.progress == 0.5)
        #expect(tween.value == 5.0)
        #expect(!tween.completed)

        tween.update(deltaTime: 0.5)

        #expect(tween.progress == 1.0)
        #expect(tween.value == 10.0)
        #expect(tween.completed)
    }

    @Test("Tween over-update")
    func tweenOverUpdate() {
        var tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        tween.update(deltaTime: 2.0)

        #expect(tween.progress == 1.0)
        #expect(tween.value == 10.0)
        #expect(tween.completed)
    }

    @Test("Tween with easing")
    func tweenWithEasing() {
        var linearTween = Tween(from: 0.0, to: 10.0, duration: 1.0, easing: Easing.linear)
        var quadTween = Tween(from: 0.0, to: 10.0, duration: 1.0, easing: Easing.quadraticIn)

        linearTween.update(deltaTime: 0.5)
        quadTween.update(deltaTime: 0.5)

        #expect(linearTween.value == 5.0)
        #expect(quadTween.value < 5.0)
    }

    @Test("Tween reset")
    func tweenReset() {
        var tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        tween.update(deltaTime: 0.5)
        tween.reset()

        #expect(tween.progress == 0.0)
        #expect(tween.value == 0.0)
        #expect(!tween.completed)
    }

    @Test("Tween seek")
    func tweenSeek() {
        var tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        tween.seek(to: 0.7)

        #expect(tween.progress == 0.7)
        #expect(abs(tween.value - 7.0) < 0.0001)
    }

    @Test("Tween seek to progress")
    func tweenSeekToProgress() {
        var tween = Tween(from: 0.0, to: 10.0, duration: 2.0)

        tween.seekToProgress(0.5)

        #expect(tween.progress == 0.5)
        #expect(tween.value == 5.0)
    }

    @Test("Tween reversed")
    func tweenReversed() {
        let tween = Tween(from: 0.0, to: 10.0, duration: 1.0)
        var reversed = tween.reversed()

        #expect(reversed.start == 10.0)
        #expect(reversed.end == 0.0)

        reversed.update(deltaTime: 0.5)
        #expect(reversed.value == 5.0)
    }

    @Test("Tween Vec2")
    func tweenVec2() {
        var tween = Tween(
            from: Vec2(x: 0, y: 0),
            to: Vec2(x: 10, y: 20),
            duration: 1.0
        )

        tween.update(deltaTime: 0.5)

        #expect(tween.value == Vec2(x: 5, y: 10))
    }

    @Test("Tween completed flag")
    func tweenCompletedFlag() {
        var tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        #expect(!tween.completed)

        tween.update(deltaTime: 1.0)
        #expect(tween.completed)

        tween.update(deltaTime: 1.0)
        #expect(tween.completed)
    }

    @Test("Tween preset quadraticIn")
    func tweenPresetQuadraticIn() {
        var tween = Tween.quadraticIn(from: 0.0, to: 10.0, duration: 1.0)

        tween.update(deltaTime: 0.5)

        #expect(tween.value == 2.5)
    }

    @Test("Tween preset quadraticOut")
    func tweenPresetQuadraticOut() {
        var tween = Tween.quadraticOut(from: 0.0, to: 10.0, duration: 1.0)

        tween.update(deltaTime: 0.5)

        #expect(abs(tween.value - 7.5) < 0.0001)
    }

    @Test("Tween preset elasticOut")
    func tweenPresetElasticOut() {
        var tween = Tween.elasticOut(from: 0.0, to: 10.0, duration: 1.0)

        tween.update(deltaTime: 1.0)

        #expect(abs(tween.value - 10.0) < 0.0001)
    }

    @Test("Tween multiple updates")
    func tweenMultipleUpdates() {
        var tween = Tween(from: 0.0, to: 10.0, duration: 1.0)

        for _ in 0..<10 {
            tween.update(deltaTime: 0.1)
        }

        // Due to floating point precision, we check if progress is very close to 1.0
        #expect(tween.progress >= 0.999)
        #expect(abs(tween.value - 10.0) < 0.0001)
    }

    @Test("Tween zero duration")
    func tweenZeroDuration() {
        let tween = Tween(from: 0.0, to: 10.0, duration: 0.0)

        #expect(tween.value == 10.0)
        #expect(tween.completed)
    }

    @Test("Tween negative values")
    func tweenNegativeValues() {
        var tween = Tween(from: -10.0, to: 10.0, duration: 1.0)

        tween.update(deltaTime: 0.5)

        #expect(tween.value == 0.0)
    }

    @Test("Tween same start and end")
    func tweenSameStartAndEnd() {
        var tween = Tween(from: 5.0, to: 5.0, duration: 1.0)

        tween.update(deltaTime: 0.5)

        #expect(tween.value == 5.0)
    }

    @Test("Tween angle interpolation")
    func tweenAngleInterpolation() {
        var tween = Tween(
            from: Angle.radians(0),
            to: Angle.radians(.pi),
            duration: 1.0
        )

        tween.update(deltaTime: 0.5)

        #expect(abs(tween.value.radians - .pi / 2) < 0.0001)
    }
}
