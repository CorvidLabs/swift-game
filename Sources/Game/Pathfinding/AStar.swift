import Foundation

/// A* pathfinding algorithm implementation.
public enum AStar {
    /// Finds a path using the A* algorithm.
    public static func findPath<G: Graph>(
        in graph: G,
        from start: G.Node,
        to goal: G.Node,
        heuristic: @escaping (G.Node, G.Node) -> Double
    ) -> Path<G.Node> {
        var openSet: Set<G.Node> = [start]
        var cameFrom: [G.Node: G.Node] = [:]
        var gScore: [G.Node: Double] = [start: 0]
        var fScore: [G.Node: Double] = [start: heuristic(start, goal)]

        while !openSet.isEmpty {
            // Find node with lowest fScore
            guard let current = openSet.min(by: { fScore[$0, default: .infinity] < fScore[$1, default: .infinity] }) else {
                break
            }

            if current == goal {
                return reconstructPath(cameFrom: cameFrom, current: current, totalCost: gScore[current, default: 0])
            }

            openSet.remove(current)

            for neighbor in graph.neighbors(of: current) {
                let tentativeGScore = gScore[current, default: .infinity] + graph.cost(from: current, to: neighbor)

                if tentativeGScore < gScore[neighbor, default: .infinity] {
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tentativeGScore
                    fScore[neighbor] = tentativeGScore + heuristic(neighbor, goal)

                    if !openSet.contains(neighbor) {
                        openSet.insert(neighbor)
                    }
                }
            }
        }

        return .notFound
    }

    /// Finds a path in a navigation grid using A*.
    public static func findPathInGrid(
        in grid: NavigationGrid,
        from start: GridCoord,
        to goal: GridCoord,
        heuristic: @escaping (GridCoord, GridCoord) -> Double = Heuristic.manhattan
    ) -> Path<GridCoord> {
        findPath(in: grid, from: start, to: goal, heuristic: heuristic)
    }

    private static func reconstructPath<Node>(
        cameFrom: [Node: Node],
        current: Node,
        totalCost: Double
    ) -> Path<Node> {
        var path: [Node] = [current]
        var currentNode = current

        while let previous = cameFrom[currentNode] {
            path.insert(previous, at: 0)
            currentNode = previous
        }

        return Path(nodes: path, cost: totalCost)
    }
}
