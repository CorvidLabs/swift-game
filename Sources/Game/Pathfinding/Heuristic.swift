import Foundation

/// Heuristic functions for pathfinding algorithms.
public enum Heuristic {
    /// Manhattan distance (grid-based movement, 4 directions).
    public static func manhattan(from: GridCoord, to: GridCoord) -> Double {
        Double(from.manhattanDistance(to: to))
    }

    /// Euclidean distance (straight-line distance).
    public static func euclidean(from: GridCoord, to: GridCoord) -> Double {
        from.euclideanDistance(to: to)
    }

    /// Chebyshev distance (grid-based movement, 8 directions).
    public static func chebyshev(from: GridCoord, to: GridCoord) -> Double {
        Double(from.chebyshevDistance(to: to))
    }

    /// Octile distance (diagonal movement with different cost).
    public static func octile(from: GridCoord, to: GridCoord) -> Double {
        let dx = abs(from.x - to.x)
        let dy = abs(from.y - to.y)
        let diagonal = min(dx, dy)
        let straight = max(dx, dy) - diagonal
        return Double(straight) + Double(diagonal) * sqrt(2)
    }

    /// Zero heuristic (transforms A* into Dijkstra's algorithm).
    public static func zero(from: GridCoord, to: GridCoord) -> Double {
        0
    }
}
