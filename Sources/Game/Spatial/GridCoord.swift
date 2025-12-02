import Foundation

/// A coordinate in a discrete 2D grid.
public struct GridCoord: Sendable, Hashable, Codable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    /// The origin coordinate (0, 0).
    public static let zero = GridCoord(x: 0, y: 0)

    /// Coordinate to the right (1, 0).
    public static let right = GridCoord(x: 1, y: 0)

    /// Coordinate above (0, 1).
    public static let up = GridCoord(x: 0, y: 1)

    /// Coordinate to the left (-1, 0).
    public static let left = GridCoord(x: -1, y: 0)

    /// Coordinate below (0, -1).
    public static let down = GridCoord(x: 0, y: -1)

    /// Returns the four orthogonal neighbors (up, down, left, right).
    public var orthogonalNeighbors: [GridCoord] {
        [
            GridCoord(x: x + 1, y: y),
            GridCoord(x: x - 1, y: y),
            GridCoord(x: x, y: y + 1),
            GridCoord(x: x, y: y - 1)
        ]
    }

    /// Returns the four diagonal neighbors.
    public var diagonalNeighbors: [GridCoord] {
        [
            GridCoord(x: x + 1, y: y + 1),
            GridCoord(x: x + 1, y: y - 1),
            GridCoord(x: x - 1, y: y + 1),
            GridCoord(x: x - 1, y: y - 1)
        ]
    }

    /// Returns all eight neighbors (orthogonal and diagonal).
    public var allNeighbors: [GridCoord] {
        orthogonalNeighbors + diagonalNeighbors
    }

    /// Calculates the Manhattan distance to another coordinate.
    public func manhattanDistance(to other: GridCoord) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }

    /// Calculates the Chebyshev distance (max of x and y distance) to another coordinate.
    public func chebyshevDistance(to other: GridCoord) -> Int {
        max(abs(x - other.x), abs(y - other.y))
    }

    /// Calculates the Euclidean distance to another coordinate.
    public func euclideanDistance(to other: GridCoord) -> Double {
        let dx = Double(x - other.x)
        let dy = Double(y - other.y)
        return sqrt(dx * dx + dy * dy)
    }

    /// Converts this grid coordinate to a world position.
    public func toWorldPosition(cellSize: Double) -> Vec2 {
        Vec2(x: Double(x) * cellSize, y: Double(y) * cellSize)
    }

    /// Creates a grid coordinate from a world position.
    public static func fromWorldPosition(_ position: Vec2, cellSize: Double) -> GridCoord {
        GridCoord(
            x: Int(floor(position.x / cellSize)),
            y: Int(floor(position.y / cellSize))
        )
    }
}

// MARK: - Operators

extension GridCoord {
    public static func + (lhs: GridCoord, rhs: GridCoord) -> GridCoord {
        GridCoord(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: GridCoord, rhs: GridCoord) -> GridCoord {
        GridCoord(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func * (lhs: GridCoord, rhs: Int) -> GridCoord {
        GridCoord(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    public static func * (lhs: Int, rhs: GridCoord) -> GridCoord {
        GridCoord(x: lhs * rhs.x, y: lhs * rhs.y)
    }
}

// MARK: - Comparable

extension GridCoord: Comparable {
    public static func < (lhs: GridCoord, rhs: GridCoord) -> Bool {
        if lhs.y != rhs.y {
            return lhs.y < rhs.y
        }
        return lhs.x < rhs.x
    }
}
