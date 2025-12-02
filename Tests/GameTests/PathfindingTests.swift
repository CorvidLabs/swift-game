import Testing
import Foundation
@testable import Game

@Suite("Pathfinding Tests")
struct PathfindingTests {
    // MARK: - Path Tests

    @Test("Path creation")
    func pathCreation() {
        let nodes = [
            GridCoord(x: 0, y: 0),
            GridCoord(x: 1, y: 0),
            GridCoord(x: 2, y: 0)
        ]
        let path = Path(nodes: nodes, cost: 2.0)

        #expect(path.found)
        #expect(path.length == 3)
        #expect(path.cost == 2.0)
        #expect(path.start == GridCoord(x: 0, y: 0))
        #expect(path.goal == GridCoord(x: 2, y: 0))
    }

    @Test("Path not found")
    func pathNotFound() {
        let path: Path<GridCoord> = .notFound

        #expect(!path.found)
        #expect(path.length == 0)
        #expect(path.cost == .infinity)
        #expect(path.start == nil)
        #expect(path.goal == nil)
    }

    @Test("Path collection conformance")
    func pathCollectionConformance() {
        let nodes = [
            GridCoord(x: 0, y: 0),
            GridCoord(x: 1, y: 0),
            GridCoord(x: 2, y: 0)
        ]
        let path = Path(nodes: nodes, cost: 2.0)

        #expect(path.count == 3)
        #expect(path[0] == GridCoord(x: 0, y: 0))
        #expect(path[1] == GridCoord(x: 1, y: 0))
        #expect(path[2] == GridCoord(x: 2, y: 0))

        var sum = 0
        for node in path {
            sum += node.x
        }
        #expect(sum == 3)
    }

    // MARK: - NavigationGrid Tests

    @Test("NavigationGrid creation")
    func navigationGridCreation() {
        let grid = NavigationGrid(width: 10, height: 10)

        #expect(grid.width == 10)
        #expect(grid.height == 10)
    }

    @Test("NavigationGrid walkability")
    func navigationGridWalkability() {
        var baseGrid = Grid2D(width: 5, height: 5, defaultValue: true)
        baseGrid[GridCoord(x: 2, y: 2)] = false

        let grid = NavigationGrid(grid: baseGrid)

        #expect(grid.isWalkable(GridCoord(x: 0, y: 0)))
        #expect(!grid.isWalkable(GridCoord(x: 2, y: 2)))
    }

    @Test("NavigationGrid neighbors")
    func navigationGridNeighbors() {
        let grid = NavigationGrid(width: 5, height: 5, allowDiagonal: false)

        let neighbors = grid.neighbors(of: GridCoord(x: 2, y: 2))
        #expect(neighbors.count == 4)

        let gridWithDiagonal = NavigationGrid(width: 5, height: 5, allowDiagonal: true)
        let diagonalNeighbors = gridWithDiagonal.neighbors(of: GridCoord(x: 2, y: 2))
        #expect(diagonalNeighbors.count == 8)
    }

    @Test("NavigationGrid neighbors with obstacles")
    func navigationGridNeighborsWithObstacles() {
        var baseGrid = Grid2D(width: 5, height: 5, defaultValue: true)
        baseGrid[GridCoord(x: 2, y: 3)] = false
        baseGrid[GridCoord(x: 3, y: 2)] = false

        let grid = NavigationGrid(grid: baseGrid)

        let neighbors = grid.neighbors(of: GridCoord(x: 2, y: 2))
        #expect(neighbors.count == 2)
    }

    @Test("NavigationGrid movement cost")
    func navigationGridMovementCost() {
        let grid = NavigationGrid(width: 5, height: 5, allowDiagonal: true)

        let orthogonalCost = grid.cost(
            from: GridCoord(x: 0, y: 0),
            to: GridCoord(x: 1, y: 0)
        )
        #expect(orthogonalCost == 1.0)

        let diagonalCost = grid.cost(
            from: GridCoord(x: 0, y: 0),
            to: GridCoord(x: 1, y: 1)
        )
        #expect(abs(diagonalCost - sqrt(2)) < 0.0001)
    }

    // MARK: - A* Pathfinding Tests

    @Test("A* simple path")
    func aStarSimplePath() {
        let grid = NavigationGrid(width: 10, height: 10)

        let start = GridCoord(x: 0, y: 0)
        let goal = GridCoord(x: 3, y: 0)

        let path = AStar.findPathInGrid(in: grid, from: start, to: goal)

        #expect(path.found)
        #expect(path.start == start)
        #expect(path.goal == goal)
        #expect(path.length == 4)
    }

    @Test("A* path with obstacles")
    func aStarPathWithObstacles() {
        var baseGrid = Grid2D(width: 10, height: 10, defaultValue: true)

        // Create a wall
        baseGrid[GridCoord(x: 2, y: 0)] = false
        baseGrid[GridCoord(x: 2, y: 1)] = false
        baseGrid[GridCoord(x: 2, y: 2)] = false

        let grid = NavigationGrid(grid: baseGrid)

        let start = GridCoord(x: 0, y: 0)
        let goal = GridCoord(x: 4, y: 0)

        let path = AStar.findPathInGrid(in: grid, from: start, to: goal)

        #expect(path.found)
        #expect(path.start == start)
        #expect(path.goal == goal)
        // Path should go around the wall
        #expect(path.length >= 5)
    }

    @Test("A* no path available")
    func aStarNoPathAvailable() {
        var baseGrid = Grid2D(width: 10, height: 10, defaultValue: true)

        // Create a complete wall
        for y in 0..<10 {
            baseGrid[GridCoord(x: 5, y: y)] = false
        }

        let grid = NavigationGrid(grid: baseGrid)

        let start = GridCoord(x: 0, y: 0)
        let goal = GridCoord(x: 9, y: 0)

        let path = AStar.findPathInGrid(in: grid, from: start, to: goal)

        #expect(!path.found)
    }

    @Test("A* diagonal movement")
    func aStarDiagonalMovement() {
        let grid = NavigationGrid(width: 10, height: 10, allowDiagonal: true)

        let start = GridCoord(x: 0, y: 0)
        let goal = GridCoord(x: 3, y: 3)

        let path = AStar.findPathInGrid(in: grid, from: start, to: goal)

        #expect(path.found)
        #expect(path.start == start)
        #expect(path.goal == goal)
        // With diagonal movement, path should be shorter
        #expect(path.length == 4)
    }

    @Test("A* manhattan heuristic")
    func aStarManhattanHeuristic() {
        let grid = NavigationGrid(width: 10, height: 10)

        let start = GridCoord(x: 0, y: 0)
        let goal = GridCoord(x: 5, y: 5)

        let path = AStar.findPathInGrid(
            in: grid,
            from: start,
            to: goal,
            heuristic: Heuristic.manhattan
        )

        #expect(path.found)
        #expect(path.start == start)
        #expect(path.goal == goal)
    }

    @Test("A* euclidean heuristic")
    func aStarEuclideanHeuristic() {
        let grid = NavigationGrid(width: 10, height: 10, allowDiagonal: true)

        let start = GridCoord(x: 0, y: 0)
        let goal = GridCoord(x: 5, y: 5)

        let path = AStar.findPathInGrid(
            in: grid,
            from: start,
            to: goal,
            heuristic: Heuristic.euclidean
        )

        #expect(path.found)
        #expect(path.start == start)
        #expect(path.goal == goal)
    }

    @Test("A* same start and goal")
    func aStarSameStartAndGoal() {
        let grid = NavigationGrid(width: 10, height: 10)

        let coord = GridCoord(x: 5, y: 5)

        let path = AStar.findPathInGrid(in: grid, from: coord, to: coord)

        #expect(path.found)
        #expect(path.length == 1)
    }

    @Test("A* complex maze")
    func aStarComplexMaze() {
        var baseGrid = Grid2D(width: 7, height: 7, defaultValue: true)

        // Create a simple maze
        // ███████
        // █S    █
        // █ ███ █
        // █   █ █
        // █ █ █ █
        // █   █G█
        // ███████

        for i in 0..<7 {
            baseGrid[GridCoord(x: 0, y: i)] = false
            baseGrid[GridCoord(x: 6, y: i)] = false
            baseGrid[GridCoord(x: i, y: 0)] = false
            baseGrid[GridCoord(x: i, y: 6)] = false
        }

        baseGrid[GridCoord(x: 2, y: 2)] = false
        baseGrid[GridCoord(x: 3, y: 2)] = false
        baseGrid[GridCoord(x: 4, y: 2)] = false
        baseGrid[GridCoord(x: 4, y: 3)] = false
        baseGrid[GridCoord(x: 4, y: 4)] = false
        baseGrid[GridCoord(x: 2, y: 4)] = false

        let grid = NavigationGrid(grid: baseGrid)

        let start = GridCoord(x: 1, y: 1)
        let goal = GridCoord(x: 5, y: 5)

        let path = AStar.findPathInGrid(in: grid, from: start, to: goal)

        #expect(path.found)
        #expect(path.start == start)
        #expect(path.goal == goal)
    }
}
