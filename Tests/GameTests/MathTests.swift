import Testing
@testable import Game

@Suite("Math Tests")
struct MathTests {
    // MARK: - Vec2 Tests

    @Test("Vec2 basic operations")
    func vec2BasicOperations() {
        let v1 = Vec2(x: 3, y: 4)
        let v2 = Vec2(x: 1, y: 2)

        #expect(v1 + v2 == Vec2(x: 4, y: 6))
        #expect(v1 - v2 == Vec2(x: 2, y: 2))
        #expect(v1 * 2 == Vec2(x: 6, y: 8))
        #expect(v1 / 2 == Vec2(x: 1.5, y: 2))
        #expect(-v1 == Vec2(x: -3, y: -4))
    }

    @Test("Vec2 magnitude and normalization")
    func vec2MagnitudeAndNormalization() {
        let v = Vec2(x: 3, y: 4)

        #expect(v.magnitude == 5.0)
        #expect(v.magnitudeSquared == 25.0)

        let normalized = v.normalized()
        #expect(abs(normalized.magnitude - 1.0) < 0.0001)
        #expect(abs(normalized.x - 0.6) < 0.0001)
        #expect(abs(normalized.y - 0.8) < 0.0001)

        // Zero vector normalization
        #expect(Vec2.zero.normalized() == Vec2.zero)
    }

    @Test("Vec2 dot and cross products")
    func vec2DotAndCrossProducts() {
        let v1 = Vec2(x: 1, y: 0)
        let v2 = Vec2(x: 0, y: 1)

        #expect(v1.dot(v2) == 0)
        #expect(Vec2(x: 1, y: 2).dot(Vec2(x: 3, y: 4)) == 11)

        // Cross product (2D returns scalar)
        #expect(v1.cross(v2) == 1.0)
        #expect(v2.cross(v1) == -1.0)
    }

    @Test("Vec2 distance calculations")
    func vec2DistanceCalculations() {
        let v1 = Vec2(x: 0, y: 0)
        let v2 = Vec2(x: 3, y: 4)

        #expect(v1.distance(to: v2) == 5.0)
        #expect(v1.distanceSquared(to: v2) == 25.0)
    }

    @Test("Vec2 angle and rotation")
    func vec2AngleAndRotation() {
        let right = Vec2.right
        #expect(abs(right.angle - 0.0) < 0.0001)

        let up = Vec2.up
        #expect(abs(up.angle - .pi / 2) < 0.0001)

        let rotated = right.rotated(by: .pi / 2)
        #expect(abs(rotated.x) < 0.0001)
        #expect(abs(rotated.y - 1.0) < 0.0001)
    }

    @Test("Vec2 perpendicular and reflection")
    func vec2PerpendicularAndReflection() {
        let v = Vec2(x: 1, y: 0)
        let perp = v.perpendicular

        #expect(perp == Vec2(x: 0, y: 1))

        let normal = Vec2(x: 0, y: 1)
        let reflected = v.reflected(across: normal)
        #expect(abs(reflected.x - 1.0) < 0.0001)
        #expect(abs(reflected.y) < 0.0001)
    }

    @Test("Vec2 projection")
    func vec2Projection() {
        let v = Vec2(x: 3, y: 4)
        let onto = Vec2(x: 1, y: 0)
        let projected = v.projected(onto: onto)

        #expect(projected == Vec2(x: 3, y: 0))
    }

    @Test("Vec2 lerp")
    func vec2Lerp() {
        let start = Vec2(x: 0, y: 0)
        let end = Vec2(x: 10, y: 10)

        #expect(start.lerp(to: end, t: 0) == start)
        #expect(start.lerp(to: end, t: 1) == end)
        #expect(start.lerp(to: end, t: 0.5) == Vec2(x: 5, y: 5))
    }

    // MARK: - Vec3 Tests

    @Test("Vec3 basic operations")
    func vec3BasicOperations() {
        let v1 = Vec3(x: 1, y: 2, z: 3)
        let v2 = Vec3(x: 4, y: 5, z: 6)

        #expect(v1 + v2 == Vec3(x: 5, y: 7, z: 9))
        #expect(v2 - v1 == Vec3(x: 3, y: 3, z: 3))
        #expect(v1 * 2 == Vec3(x: 2, y: 4, z: 6))
        #expect(v1 / 2 == Vec3(x: 0.5, y: 1, z: 1.5))
    }

    @Test("Vec3 magnitude and normalization")
    func vec3MagnitudeAndNormalization() {
        let v = Vec3(x: 2, y: 3, z: 6)

        #expect(v.magnitude == 7.0)
        #expect(v.magnitudeSquared == 49.0)

        let normalized = v.normalized()
        #expect(abs(normalized.magnitude - 1.0) < 0.0001)
    }

    @Test("Vec3 dot and cross products")
    func vec3DotAndCrossProducts() {
        let v1 = Vec3(x: 1, y: 0, z: 0)
        let v2 = Vec3(x: 0, y: 1, z: 0)

        #expect(v1.dot(v2) == 0)

        let cross = v1.cross(v2)
        #expect(cross == Vec3(x: 0, y: 0, z: 1))
    }

    @Test("Vec3 component access")
    func vec3ComponentAccess() {
        let v = Vec3(x: 1, y: 2, z: 3)

        #expect(v.xy == Vec2(x: 1, y: 2))
        #expect(v.xz == Vec2(x: 1, y: 3))
    }

    // MARK: - Interpolation Tests

    @Test("Linear interpolation")
    func linearInterpolation() {
        #expect(Interpolation.lerp(from: 0, to: 10, t: 0) == 0)
        #expect(Interpolation.lerp(from: 0, to: 10, t: 1) == 10)
        #expect(Interpolation.lerp(from: 0, to: 10, t: 0.5) == 5)
        #expect(Interpolation.lerp(from: 10, to: 20, t: 0.3) == 13)
    }

    @Test("Inverse lerp")
    func inverseLerp() {
        #expect(Interpolation.inverseLerp(from: 0, to: 10, value: 5) == 0.5)
        #expect(Interpolation.inverseLerp(from: 10, to: 20, value: 15) == 0.5)
        #expect(Interpolation.inverseLerp(from: 0, to: 100, value: 25) == 0.25)
    }

    @Test("Remap")
    func remap() {
        let result = Interpolation.remap(
            value: 5,
            fromRange: 0...10,
            toRange: 0...100
        )
        #expect(result == 50)

        let result2 = Interpolation.remap(
            value: 0.5,
            fromRange: 0...1,
            toRange: 10...20
        )
        #expect(result2 == 15)
    }

    @Test("Smoothstep")
    func smoothstep() {
        #expect(Interpolation.smoothstep(0) == 0)
        #expect(Interpolation.smoothstep(1) == 1)

        let mid = Interpolation.smoothstep(0.5)
        #expect(mid > 0.4 && mid < 0.6)
    }

    @Test("Smootherstep")
    func smootherstep() {
        #expect(Interpolation.smootherstep(0) == 0)
        #expect(Interpolation.smootherstep(1) == 1)

        let mid = Interpolation.smootherstep(0.5)
        #expect(mid == 0.5)
    }

    @Test("Clamp")
    func clamp() {
        #expect(Interpolation.clamp(5, min: 0, max: 10) == 5)
        #expect(Interpolation.clamp(-5, min: 0, max: 10) == 0)
        #expect(Interpolation.clamp(15, min: 0, max: 10) == 10)
        #expect(Interpolation.clamp01(0.5) == 0.5)
        #expect(Interpolation.clamp01(-0.5) == 0)
        #expect(Interpolation.clamp01(1.5) == 1)
    }

    @Test("Move towards")
    func moveTowards() {
        #expect(Interpolation.moveTowards(current: 0, target: 10, maxDelta: 5) == 5)
        #expect(Interpolation.moveTowards(current: 0, target: 10, maxDelta: 20) == 10)
        #expect(Interpolation.moveTowards(current: 10, target: 0, maxDelta: 3) == 7)
    }

    // MARK: - Easing Tests

    @Test("Easing boundary conditions")
    func easingBoundaryConditions() {
        let easingFunctions: [(Double) -> Double] = [
            Easing.linear,
            Easing.quadraticIn, Easing.quadraticOut, Easing.quadraticInOut,
            Easing.cubicIn, Easing.cubicOut, Easing.cubicInOut,
            Easing.quarticIn, Easing.quarticOut, Easing.quarticInOut,
            Easing.quinticIn, Easing.quinticOut, Easing.quinticInOut,
            Easing.sineIn, Easing.sineOut, Easing.sineInOut,
            Easing.exponentialIn, Easing.exponentialOut, Easing.exponentialInOut,
            Easing.circularIn, Easing.circularOut, Easing.circularInOut,
            Easing.elasticIn, Easing.elasticOut, Easing.elasticInOut,
            Easing.backIn, Easing.backOut, Easing.backInOut,
            Easing.bounceIn, Easing.bounceOut, Easing.bounceInOut
        ]

        for easing in easingFunctions {
            let resultAt0 = easing(0)
            let resultAt1 = easing(1)

            #expect(abs(resultAt0 - 0) < 0.0001, "Easing should return 0 at t=0")
            #expect(abs(resultAt1 - 1) < 0.0001, "Easing should return 1 at t=1")
        }
    }

    @Test("Quadratic easing")
    func quadraticEasing() {
        #expect(Easing.quadraticIn(0.5) == 0.25)
        #expect(abs(Easing.quadraticOut(0.5) - 0.75) < 0.0001)
    }

    @Test("Cubic easing")
    func cubicEasing() {
        #expect(Easing.cubicIn(0.5) == 0.125)
        #expect(abs(Easing.cubicOut(0.5) - 0.875) < 0.0001)
    }

    @Test("Linear easing")
    func linearEasing() {
        #expect(Easing.linear(0.5) == 0.5)
        #expect(Easing.linear(0.25) == 0.25)
        #expect(Easing.linear(0.75) == 0.75)
    }

    // MARK: - Angle Tests

    @Test("Angle creation and conversion")
    func angleCreationAndConversion() {
        let radAngle = Angle.radians(.pi)
        #expect(abs(radAngle.degrees - 180) < 0.0001)

        let degAngle = Angle.degrees(90)
        #expect(abs(degAngle.radians - .pi / 2) < 0.0001)
    }

    @Test("Angle normalization")
    func angleNormalization() {
        let angle = Angle.radians(3 * .pi)
        let normalized = angle.normalized()

        #expect(abs(normalized.radians - .pi) < 0.0001)

        let signedAngle = Angle.radians(1.5 * .pi)
        let normalizedSigned = signedAngle.normalizedSigned()
        #expect(abs(normalizedSigned.radians - (-0.5 * .pi)) < 0.0001)
    }

    @Test("Angle difference")
    func angleDifference() {
        let a1 = Angle.radians(0)
        let a2 = Angle.radians(.pi / 2)

        let diff = a1.difference(to: a2)
        #expect(abs(diff.radians - .pi / 2) < 0.0001)
    }

    @Test("Angle lerp")
    func angleLerp() {
        let start = Angle.radians(0)
        let end = Angle.radians(.pi)

        let mid = start.lerp(to: end, t: 0.5)
        #expect(abs(mid.radians - .pi / 2) < 0.0001)
    }
}
