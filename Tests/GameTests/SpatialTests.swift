import Testing
@testable import Game

@Suite("Spatial Tests")
struct SpatialTests {
    // MARK: - GridCoord Tests

    @Test("GridCoord basic operations")
    func gridCoordBasicOperations() {
        let coord1 = GridCoord(x: 5, y: 10)
        let coord2 = GridCoord(x: 3, y: 2)

        #expect(coord1 + coord2 == GridCoord(x: 8, y: 12))
        #expect(coord1 - coord2 == GridCoord(x: 2, y: 8))
        #expect(coord1 * 2 == GridCoord(x: 10, y: 20))
    }

    @Test("GridCoord neighbors")
    func gridCoordNeighbors() {
        let coord = GridCoord(x: 5, y: 5)
        let orthogonal = coord.orthogonalNeighbors

        #expect(orthogonal.count == 4)
        #expect(orthogonal.contains(GridCoord(x: 6, y: 5)))
        #expect(orthogonal.contains(GridCoord(x: 4, y: 5)))
        #expect(orthogonal.contains(GridCoord(x: 5, y: 6)))
        #expect(orthogonal.contains(GridCoord(x: 5, y: 4)))

        let diagonal = coord.diagonalNeighbors
        #expect(diagonal.count == 4)

        let all = coord.allNeighbors
        #expect(all.count == 8)
    }

    @Test("GridCoord distance calculations")
    func gridCoordDistanceCalculations() {
        let coord1 = GridCoord(x: 0, y: 0)
        let coord2 = GridCoord(x: 3, y: 4)

        #expect(coord1.manhattanDistance(to: coord2) == 7)
        #expect(coord1.chebyshevDistance(to: coord2) == 4)
        #expect(abs(coord1.euclideanDistance(to: coord2) - 5.0) < 0.0001)
    }

    @Test("GridCoord world position conversion")
    func gridCoordWorldPositionConversion() {
        let coord = GridCoord(x: 5, y: 10)
        let worldPos = coord.toWorldPosition(cellSize: 2.0)

        #expect(worldPos == Vec2(x: 10, y: 20))

        let converted = GridCoord.fromWorldPosition(worldPos, cellSize: 2.0)
        #expect(converted == coord)
    }

    // MARK: - Grid2D Tests

    @Test("Grid2D creation and access")
    func grid2DCreationAndAccess() {
        let grid = Grid2D(width: 10, height: 10, defaultValue: 0)

        #expect(grid.width == 10)
        #expect(grid.height == 10)
        #expect(grid[GridCoord(x: 0, y: 0)] == 0)
    }

    @Test("Grid2D subscript access")
    func grid2DSubscriptAccess() {
        var grid = Grid2D(width: 5, height: 5, defaultValue: 0)

        grid[GridCoord(x: 2, y: 3)] = 42
        #expect(grid[GridCoord(x: 2, y: 3)] == 42)
        #expect(grid[2, 3] == 42)

        grid[1, 1] = 99
        #expect(grid[GridCoord(x: 1, y: 1)] == 99)
    }

    @Test("Grid2D bounds checking")
    func grid2DBoundsChecking() {
        let grid = Grid2D(width: 5, height: 5, defaultValue: 0)

        #expect(grid.isValid(GridCoord(x: 0, y: 0)))
        #expect(grid.isValid(GridCoord(x: 4, y: 4)))
        #expect(!grid.isValid(GridCoord(x: -1, y: 0)))
        #expect(!grid.isValid(GridCoord(x: 5, y: 0)))
        #expect(!grid.isValid(GridCoord(x: 0, y: 5)))
    }

    @Test("Grid2D neighbors")
    func grid2DNeighbors() {
        let grid = Grid2D(width: 5, height: 5, defaultValue: 0)

        let cornerNeighbors = grid.orthogonalNeighbors(of: GridCoord(x: 0, y: 0))
        #expect(cornerNeighbors.count == 2)

        let centerNeighbors = grid.orthogonalNeighbors(of: GridCoord(x: 2, y: 2))
        #expect(centerNeighbors.count == 4)

        let allNeighbors = grid.allNeighbors(of: GridCoord(x: 2, y: 2))
        #expect(allNeighbors.count == 8)
    }

    @Test("Grid2D generator initialization")
    func grid2DGeneratorInitialization() {
        let grid = Grid2D(width: 3, height: 3) { coord in
            coord.x + coord.y
        }

        #expect(grid[0, 0] == 0)
        #expect(grid[1, 1] == 2)
        #expect(grid[2, 2] == 4)
    }

    @Test("Grid2D map transformation")
    func grid2DMapTransformation() {
        let grid = Grid2D(width: 3, height: 3, defaultValue: 5)
        let doubled = grid.map { $0 * 2 }

        #expect(doubled[0, 0] == 10)
        #expect(doubled[2, 2] == 10)
    }

    @Test("Grid2D coordinates filtering")
    func grid2DCoordinatesFiltering() {
        let grid = Grid2D(width: 3, height: 3) { coord in
            coord.x + coord.y
        }

        let evenCoords = grid.coordinates { $0 % 2 == 0 }
        #expect(evenCoords.count == 5)
    }

    // MARK: - Quadtree Tests

    @Test("Quadtree insertion")
    func quadtreeInsertion() async {
        let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Quadtree<Int>(bounds: bounds, capacity: 4)

        let item1 = Quadtree<Int>.Item(position: Vec2(x: 10, y: 10), element: 1)
        let item2 = Quadtree<Int>.Item(position: Vec2(x: 20, y: 20), element: 2)
        let item3 = Quadtree<Int>.Item(position: Vec2(x: 30, y: 30), element: 3)

        let result1 = await quadtree.insert(item1)
        let result2 = await quadtree.insert(item2)
        let result3 = await quadtree.insert(item3)

        #expect(result1)
        #expect(result2)
        #expect(result3)
    }

    @Test("Quadtree insertion out of bounds")
    func quadtreeInsertionOutOfBounds() async {
        let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Quadtree<Int>(bounds: bounds)

        let outOfBounds = Quadtree<Int>.Item(position: Vec2(x: 200, y: 200), element: 1)
        let result = await quadtree.insert(outOfBounds)
        #expect(!result)
    }

    @Test("Quadtree query range")
    func quadtreeQueryRange() async {
        let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Quadtree<Int>(bounds: bounds)

        for i in 0..<10 {
            let item = Quadtree<Int>.Item(
                position: Vec2(x: Double(i * 10), y: Double(i * 10)),
                element: i
            )
            _ = await quadtree.insert(item)
        }

        let searchArea = AABB(x: 0, y: 0, width: 30, height: 30)
        let found = await quadtree.query(in: searchArea)

        #expect(found.count >= 3)
    }

    @Test("Quadtree query near point")
    func quadtreeQueryNearPoint() async {
        let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Quadtree<Int>(bounds: bounds)

        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 50, y: 50), element: 1))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 52, y: 52), element: 2))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 80, y: 80), element: 3))

        let nearby = await quadtree.query(near: Vec2(x: 50, y: 50), radius: 5)
        #expect(nearby.count == 2)
    }

    @Test("Quadtree nearest item")
    func quadtreeNearestItem() async {
        let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Quadtree<Int>(bounds: bounds)

        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 10, y: 10), element: 1))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 50, y: 50), element: 2))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 90, y: 90), element: 3))

        let nearest = await quadtree.nearest(to: Vec2(x: 12, y: 12))
        #expect(nearest != nil)
        #expect(nearest?.element == 1)
    }

    @Test("Quadtree subdivision")
    func quadtreeSubdivision() async {
        let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Quadtree<Int>(bounds: bounds, capacity: 2)

        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 10, y: 10), element: 1))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 20, y: 20), element: 2))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 30, y: 30), element: 3))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 40, y: 40), element: 4))

        let searchArea = AABB(x: 0, y: 0, width: 100, height: 100)
        let all = await quadtree.query(in: searchArea)
        #expect(all.count == 4)
    }

    @Test("Quadtree clear")
    func quadtreeClear() async {
        let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Quadtree<Int>(bounds: bounds)

        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 10, y: 10), element: 1))
        _ = await quadtree.insert(Quadtree<Int>.Item(position: Vec2(x: 20, y: 20), element: 2))

        await quadtree.clear()

        let searchArea = AABB(x: 0, y: 0, width: 100, height: 100)
        let found = await quadtree.query(in: searchArea)
        #expect(found.isEmpty)
    }
}
