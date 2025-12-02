import Foundation

/// A navigation grid for pathfinding with walkability information.
public struct NavigationGrid: Sendable {
    private let grid: Grid2D<Bool>
    private let allowDiagonal: Bool

    /// Creates a navigation grid with walkability information.
    /// - Parameters:
    ///   - grid: Grid where true indicates walkable, false indicates blocked.
    ///   - allowDiagonal: Whether diagonal movement is allowed.
    public init(grid: Grid2D<Bool>, allowDiagonal: Bool = false) {
        self.grid = grid
        self.allowDiagonal = allowDiagonal
    }

    /// Creates a navigation grid with all cells walkable.
    public init(width: Int, height: Int, allowDiagonal: Bool = false) {
        self.grid = Grid2D(width: width, height: height, defaultValue: true)
        self.allowDiagonal = allowDiagonal
    }

    /// The width of the navigation grid.
    public var width: Int {
        grid.width
    }

    /// The height of the navigation grid.
    public var height: Int {
        grid.height
    }

    /// Checks if a coordinate is walkable.
    public func isWalkable(_ coord: GridCoord) -> Bool {
        grid[coord] ?? false
    }

    /// Checks if a coordinate is valid and within bounds.
    public func isValid(_ coord: GridCoord) -> Bool {
        grid.isValid(coord)
    }

    /// Sets the walkability of a coordinate.
    public mutating func setWalkable(_ coord: GridCoord, walkable: Bool) {
        guard grid.isValid(coord) else { return }
        var mutableGrid = grid
        mutableGrid[coord] = walkable
    }
}

// MARK: - Graph Conformance

extension NavigationGrid: Graph {
    public func neighbors(of node: GridCoord) -> [GridCoord] {
        let candidates = allowDiagonal
            ? grid.allNeighbors(of: node)
            : grid.orthogonalNeighbors(of: node)

        return candidates.filter { isWalkable($0) }
    }

    public func cost(from: GridCoord, to: GridCoord) -> Double {
        let isDiagonal = from.x != to.x && from.y != to.y
        return isDiagonal ? sqrt(2) : 1.0
    }
}
