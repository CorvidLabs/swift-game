import Foundation

/// Represents a dice roll using standard RPG notation (e.g., 2d6+3).
public struct Dice: Sendable, Hashable {
    public let count: Int
    public let sides: Int
    public let modifier: Int

    public init(count: Int, sides: Int, modifier: Int = 0) {
        self.count = count
        self.sides = sides
        self.modifier = modifier
    }

    /// Parses dice notation (e.g., "2d6+3", "1d20", "3d8-2").
    public init?(notation: String) {
        let pattern = #"^(\d+)d(\d+)([+-]\d+)?$"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }

        let range = NSRange(notation.startIndex..<notation.endIndex, in: notation)
        guard let match = regex.firstMatch(in: notation, range: range) else {
            return nil
        }

        guard let countRange = Range(match.range(at: 1), in: notation),
              let sidesRange = Range(match.range(at: 2), in: notation),
              let count = Int(notation[countRange]),
              let sides = Int(notation[sidesRange]) else {
            return nil
        }

        var modifier = 0
        if match.range(at: 3).location != NSNotFound,
           let modRange = Range(match.range(at: 3), in: notation) {
            modifier = Int(notation[modRange]) ?? 0
        }

        self.count = count
        self.sides = sides
        self.modifier = modifier
    }

    /// Rolls the dice and returns the result.
    public func roll(using random: inout GameRandom) -> Int {
        var total = modifier
        for _ in 0..<count {
            total += random.nextInt(in: 1...sides)
        }
        return total
    }

    /// Returns the minimum possible roll.
    public var minimum: Int {
        count + modifier
    }

    /// Returns the maximum possible roll.
    public var maximum: Int {
        count * sides + modifier
    }

    /// Returns the average roll value.
    public var average: Double {
        Double(count) * Double(sides + 1) / 2.0 + Double(modifier)
    }

    /// Common dice presets.
    public static let d4 = Dice(count: 1, sides: 4)
    public static let d6 = Dice(count: 1, sides: 6)
    public static let d8 = Dice(count: 1, sides: 8)
    public static let d10 = Dice(count: 1, sides: 10)
    public static let d12 = Dice(count: 1, sides: 12)
    public static let d20 = Dice(count: 1, sides: 20)
    public static let d100 = Dice(count: 1, sides: 100)

    /// 2d6 (common in many games).
    public static let twod6 = Dice(count: 2, sides: 6)

    /// 3d6 (common for stats).
    public static let threed6 = Dice(count: 3, sides: 6)
}

// MARK: - CustomStringConvertible

extension Dice: CustomStringConvertible {
    public var description: String {
        var result = "\(count)d\(sides)"
        if modifier > 0 {
            result += "+\(modifier)"
        } else if modifier < 0 {
            result += "\(modifier)"
        }
        return result
    }
}
