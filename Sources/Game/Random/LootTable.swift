import Foundation

/// A loot table for generating random rewards and drops.
public struct LootTable<Item: Sendable>: Sendable {
    /// An entry in the loot table.
    public struct Entry: Sendable {
        public let item: Item
        public let weight: Double
        public let quantity: ClosedRange<Int>

        public init(item: Item, weight: Double, quantity: ClosedRange<Int> = 1...1) {
            self.item = item
            self.weight = weight
            self.quantity = quantity
        }
    }

    /// The result of a loot roll.
    public struct LootResult: Sendable {
        public let item: Item
        public let quantity: Int

        public init(item: Item, quantity: Int) {
            self.item = item
            self.quantity = quantity
        }
    }

    private let entries: [Entry]
    private let dropChance: Double

    /// Creates a loot table with the given entries.
    /// - Parameters:
    ///   - entries: The items that can be dropped.
    ///   - dropChance: The probability that any loot drops (0.0 to 1.0).
    public init(entries: [Entry], dropChance: Double = 1.0) {
        self.entries = entries
        self.dropChance = max(0, min(1, dropChance))
    }

    /// Rolls the loot table and returns a single item if successful.
    public func roll(using random: inout GameRandom) -> LootResult? {
        guard random.nextBool(probability: dropChance) else { return nil }

        let weighted = WeightedRandom(
            items: entries.map { ($0, $0.weight) }
        )

        guard let entry = weighted.select(using: &random) else { return nil }

        let quantity = random.nextInt(in: entry.quantity)
        return LootResult(item: entry.item, quantity: quantity)
    }

    /// Rolls the loot table multiple times.
    public func roll(count: Int, using random: inout GameRandom) -> [LootResult] {
        (0..<count).compactMap { _ in roll(using: &random) }
    }

    /// Rolls the loot table and groups results by item.
    public func rollCombined(count: Int, using random: inout GameRandom) -> [Item: Int] where Item: Hashable {
        var results: [Item: Int] = [:]

        for _ in 0..<count {
            if let result = roll(using: &random) {
                results[result.item, default: 0] += result.quantity
            }
        }

        return results
    }

    /// Creates a guaranteed loot table (100% drop chance).
    public static func guaranteed(entries: [Entry]) -> LootTable {
        LootTable(entries: entries, dropChance: 1.0)
    }

    /// Creates a rare loot table (low drop chance).
    public static func rare(entries: [Entry], dropChance: Double = 0.1) -> LootTable {
        LootTable(entries: entries, dropChance: dropChance)
    }
}
