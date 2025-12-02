import Foundation

/// Provides weighted random selection from a collection of items.
public struct WeightedRandom<Element: Sendable>: Sendable {
    /// An item with its associated weight.
    public struct WeightedItem: Sendable {
        public let element: Element
        public let weight: Double

        public init(element: Element, weight: Double) {
            self.element = element
            self.weight = weight
        }
    }

    private let items: [WeightedItem]
    private let totalWeight: Double

    /// Creates a weighted random selector from weighted items.
    public init(items: [WeightedItem]) {
        self.items = items
        self.totalWeight = items.reduce(0) { $0 + $1.weight }
    }

    /// Creates a weighted random selector from elements and weights.
    public init(items: [(element: Element, weight: Double)]) {
        self.init(items: items.map { WeightedItem(element: $0.element, weight: $0.weight) })
    }

    /// Selects a random item based on weights.
    public func select(using random: inout GameRandom) -> Element? {
        guard !items.isEmpty, totalWeight > 0 else { return nil }

        let randomValue = random.nextDouble() * totalWeight
        var accumulated = 0.0

        for item in items {
            accumulated += item.weight
            if randomValue <= accumulated {
                return item.element
            }
        }

        return items.last?.element
    }

    /// Selects multiple random items with replacement.
    public func select(count: Int, using random: inout GameRandom) -> [Element] {
        (0..<count).compactMap { _ in select(using: &random) }
    }

    /// Selects multiple random items without replacement.
    public func selectUnique(count: Int, using random: inout GameRandom) -> [Element] {
        var remaining = items
        var selected: [Element] = []
        var totalWeight = self.totalWeight

        for _ in 0..<min(count, items.count) {
            guard !remaining.isEmpty, totalWeight > 0 else { break }

            let randomValue = random.nextDouble() * totalWeight
            var accumulated = 0.0

            for (index, item) in remaining.enumerated() {
                accumulated += item.weight
                if randomValue <= accumulated {
                    selected.append(item.element)
                    totalWeight -= item.weight
                    remaining.remove(at: index)
                    break
                }
            }
        }

        return selected
    }

    /// The number of items in the weighted collection.
    public var count: Int {
        items.count
    }

    /// Whether the weighted collection is empty.
    public var isEmpty: Bool {
        items.isEmpty
    }
}
