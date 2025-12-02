import Foundation

/// A seedable pseudo-random number generator for games using xorshift128+.
public struct GameRandom: Sendable {
    private var state0: UInt64
    private var state1: UInt64

    /// Creates a random generator with the given seed.
    public init(seed: UInt64) {
        self.state0 = seed != 0 ? seed : 1
        self.state1 = seed != 0 ? seed ^ 0x123456789ABCDEF0 : 0x123456789ABCDEF0
    }

    /// Creates a random generator with a seed based on the current time.
    public init() {
        self.init(seed: UInt64(Date().timeIntervalSince1970 * 1_000_000))
    }

    /// Generates the next random UInt64 using xorshift128+.
    public mutating func nextUInt64() -> UInt64 {
        var s1 = state0
        let s0 = state1
        state0 = s0
        s1 ^= s1 << 23
        s1 ^= s1 >> 17
        s1 ^= s0
        s1 ^= s0 >> 26
        state1 = s1
        return s1 &+ s0
    }

    /// Generates a random Double in the range [0, 1).
    public mutating func nextDouble() -> Double {
        Double(nextUInt64() >> 11) * 0x1.0p-53
    }

    /// Generates a random Double in the specified range.
    public mutating func nextDouble(in range: ClosedRange<Double>) -> Double {
        let normalized = nextDouble()
        return range.lowerBound + normalized * (range.upperBound - range.lowerBound)
    }

    /// Generates a random Float in the range [0, 1).
    public mutating func nextFloat() -> Float {
        Float(nextDouble())
    }

    /// Generates a random Float in the specified range.
    public mutating func nextFloat(in range: ClosedRange<Float>) -> Float {
        let normalized = nextFloat()
        return range.lowerBound + normalized * (range.upperBound - range.lowerBound)
    }

    /// Generates a random Int in the range [0, upperBound).
    public mutating func nextInt(upperBound: Int) -> Int {
        guard upperBound > 0 else { return 0 }
        return Int(nextUInt64() % UInt64(upperBound))
    }

    /// Generates a random Int in the specified range.
    public mutating func nextInt(in range: ClosedRange<Int>) -> Int {
        let count = range.upperBound - range.lowerBound + 1
        return range.lowerBound + nextInt(upperBound: count)
    }

    /// Generates a random Bool with the given probability of being true.
    public mutating func nextBool(probability: Double = 0.5) -> Bool {
        nextDouble() < probability
    }

    /// Returns a random element from the given array.
    public mutating func nextElement<T>(from array: [T]) -> T? {
        guard !array.isEmpty else { return nil }
        let index = nextInt(upperBound: array.count)
        return array[index]
    }

    /// Shuffles an array in place using Fisher-Yates algorithm.
    public mutating func shuffle<T>(_ array: inout [T]) {
        guard array.count > 1 else { return }

        for i in (1..<array.count).reversed() {
            let j = nextInt(upperBound: i + 1)
            array.swapAt(i, j)
        }
    }

    /// Returns a shuffled copy of the array.
    public mutating func shuffled<T>(_ array: [T]) -> [T] {
        var result = array
        shuffle(&result)
        return result
    }

    /// Generates a random Vec2 within the specified bounds.
    public mutating func nextVec2(
        xRange: ClosedRange<Double> = 0...1,
        yRange: ClosedRange<Double> = 0...1
    ) -> Vec2 {
        Vec2(
            x: nextDouble(in: xRange),
            y: nextDouble(in: yRange)
        )
    }

    /// Generates a random Vec3 within the specified bounds.
    public mutating func nextVec3(
        xRange: ClosedRange<Double> = 0...1,
        yRange: ClosedRange<Double> = 0...1,
        zRange: ClosedRange<Double> = 0...1
    ) -> Vec3 {
        Vec3(
            x: nextDouble(in: xRange),
            y: nextDouble(in: yRange),
            z: nextDouble(in: zRange)
        )
    }

    /// Generates a random angle in radians [0, 2π).
    public mutating func nextAngle() -> Angle {
        .radians(nextDouble() * 2 * .pi)
    }

    /// Generates a random unit vector (direction).
    public mutating func nextDirection2D() -> Vec2 {
        Vec2.fromAngle(nextDouble() * 2 * .pi)
    }

    /// Generates a random GridCoord within the specified bounds.
    public mutating func nextGridCoord(
        xRange: ClosedRange<Int>,
        yRange: ClosedRange<Int>
    ) -> GridCoord {
        GridCoord(
            x: nextInt(in: xRange),
            y: nextInt(in: yRange)
        )
    }
}
