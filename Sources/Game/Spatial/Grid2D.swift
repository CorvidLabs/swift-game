import Foundation

/// A generic 2D grid data structure.
public struct Grid2D<Element: Sendable>: Sendable {
    public let width: Int
    public let height: Int
    private var storage: [Element]

    /// Creates a grid filled with the default value.
    public init(width: Int, height: Int, defaultValue: Element) {
        self.width = width
        self.height = height
        self.storage = Array(repeating: defaultValue, count: width * height)
    }

    /// Creates a grid using a generator function.
    public init(width: Int, height: Int, generator: (GridCoord) -> Element) {
        self.width = width
        self.height = height
        self.storage = (0..<height).flatMap { y in
            (0..<width).map { x in
                generator(GridCoord(x: x, y: y))
            }
        }
    }

    /// Checks if a coordinate is within the grid bounds.
    public func isValid(_ coord: GridCoord) -> Bool {
        coord.x >= 0 && coord.x < width && coord.y >= 0 && coord.y < height
    }

    /// Gets the element at the given coordinate.
    public subscript(coord: GridCoord) -> Element? {
        get {
            guard isValid(coord) else { return nil }
            return storage[coord.y * width + coord.x]
        }
        set {
            guard isValid(coord), let newValue else { return }
            storage[coord.y * width + coord.x] = newValue
        }
    }

    /// Gets the element at the given x, y position.
    public subscript(x: Int, y: Int) -> Element? {
        get {
            self[GridCoord(x: x, y: y)]
        }
        set {
            self[GridCoord(x: x, y: y)] = newValue
        }
    }

    /// Returns all valid orthogonal neighbors of a coordinate.
    public func orthogonalNeighbors(of coord: GridCoord) -> [GridCoord] {
        coord.orthogonalNeighbors.filter { isValid($0) }
    }

    /// Returns all valid neighbors (orthogonal and diagonal) of a coordinate.
    public func allNeighbors(of coord: GridCoord) -> [GridCoord] {
        coord.allNeighbors.filter { isValid($0) }
    }

    /// Returns all coordinates in the grid.
    public var allCoordinates: [GridCoord] {
        (0..<height).flatMap { y in
            (0..<width).map { x in
                GridCoord(x: x, y: y)
            }
        }
    }

    /// Applies a transformation to each element in the grid.
    public func map<T: Sendable>(_ transform: (Element) -> T) -> Grid2D<T> {
        Grid2D<T>(width: width, height: height) { coord in
            transform(self[coord]!)
        }
    }

    /// Returns coordinates that satisfy the predicate.
    public func coordinates(where predicate: (Element) -> Bool) -> [GridCoord] {
        allCoordinates.filter { coord in
            if let element = self[coord] {
                return predicate(element)
            }
            return false
        }
    }

    /// Fills a region of the grid with a value.
    public mutating func fill(_ value: Element, in region: AABB) {
        let minX = max(0, Int(region.min.x))
        let minY = max(0, Int(region.min.y))
        let maxX = min(width - 1, Int(region.max.x))
        let maxY = min(height - 1, Int(region.max.y))

        for y in minY...maxY {
            for x in minX...maxX {
                self[x, y] = value
            }
        }
    }

    /// Returns a subgrid from the specified region.
    public func subgrid(in region: AABB) -> Grid2D<Element>? where Element: Equatable {
        let minX = max(0, Int(region.min.x))
        let minY = max(0, Int(region.min.y))
        let maxX = min(width - 1, Int(region.max.x))
        let maxY = min(height - 1, Int(region.max.y))

        guard minX <= maxX && minY <= maxY else { return nil }

        let newWidth = maxX - minX + 1
        let newHeight = maxY - minY + 1

        return Grid2D<Element>(width: newWidth, height: newHeight) { coord in
            self[coord.x + minX, coord.y + minY]!
        }
    }
}

// MARK: - Equatable

extension Grid2D: Equatable where Element: Equatable {
    public static func == (lhs: Grid2D<Element>, rhs: Grid2D<Element>) -> Bool {
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.storage == rhs.storage
    }
}

// MARK: - Hashable

extension Grid2D: Hashable where Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(storage)
    }
}
