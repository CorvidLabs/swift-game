import Foundation

/// A spatial hash for efficient broad-phase collision detection.
public struct SpatialHash<Element: Hashable & Sendable>: Sendable {
    /// An item stored in the spatial hash with its bounding box.
    public struct Item: Sendable, Hashable {
        public let bounds: AABB
        public let element: Element

        public init(bounds: AABB, element: Element) {
            self.bounds = bounds
            self.element = element
        }

        public static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.element == rhs.element
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(element)
        }
    }

    private let cellSize: Double
    private var cells: [GridCoord: Set<Item>] = [:]

    /// Creates a spatial hash with the given cell size.
    public init(cellSize: Double) {
        self.cellSize = cellSize
    }

    /// Inserts an item into the spatial hash.
    public mutating func insert(_ item: Item) {
        let cells = getCells(for: item.bounds)
        for cell in cells {
            self.cells[cell, default: []].insert(item)
        }
    }

    /// Removes an item from the spatial hash.
    public mutating func remove(_ item: Item) {
        let cells = getCells(for: item.bounds)
        for cell in cells {
            self.cells[cell]?.remove(item)
            if self.cells[cell]?.isEmpty == true {
                self.cells[cell] = nil
            }
        }
    }

    /// Queries items that potentially intersect with the given bounds.
    public func query(in bounds: AABB) -> Set<Item> {
        let cells = getCells(for: bounds)
        var results = Set<Item>()

        for cell in cells {
            if let items = self.cells[cell] {
                results.formUnion(items)
            }
        }

        return results
    }

    /// Queries items near a point within a given radius.
    public func query(near point: Vec2, radius: Double) -> Set<Item> {
        let searchBounds = AABB(
            center: point,
            size: Vec2(x: radius * 2, y: radius * 2)
        )
        return query(in: searchBounds)
    }

    /// Clears all items from the spatial hash.
    public mutating func clear() {
        cells.removeAll()
    }

    /// Updates an item's position in the spatial hash.
    public mutating func update(_ item: Item, newBounds: AABB) {
        remove(item)
        let newItem = Item(bounds: newBounds, element: item.element)
        insert(newItem)
    }

    private func getCells(for bounds: AABB) -> [GridCoord] {
        let minCell = GridCoord.fromWorldPosition(bounds.min, cellSize: cellSize)
        let maxCell = GridCoord.fromWorldPosition(bounds.max, cellSize: cellSize)

        var cells: [GridCoord] = []
        for y in minCell.y...maxCell.y {
            for x in minCell.x...maxCell.x {
                cells.append(GridCoord(x: x, y: y))
            }
        }
        return cells
    }
}
