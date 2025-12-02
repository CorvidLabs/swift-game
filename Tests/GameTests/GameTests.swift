import Testing
@testable import Game

@Suite("Game")
struct GameTests {
    @Test("Vec2 math")
    func vec2Math() {
        let v1 = Vec2(x: 3, y: 4)
        #expect(abs(v1.magnitude - 5.0) < 0.001)

        let v2 = Vec2(x: 1, y: 0)
        #expect(v1.dot(v2) == 3.0)

        let normalized = v1.normalized()
        #expect(abs(normalized.magnitude - 1.0) < 0.001)
    }

    @Test("Grid coord")
    func gridCoord() {
        let coord = GridCoord(x: 5, y: 10)
        let neighbors = coord.orthogonalNeighbors

        #expect(neighbors.count == 4)
        #expect(neighbors.contains(GridCoord(x: 6, y: 10)))
        #expect(neighbors.contains(GridCoord(x: 4, y: 10)))
    }

    @Test("Cooldown")
    func cooldown() {
        var cooldown = Cooldown(duration: 1.0)
        #expect(cooldown.isReady)

        cooldown.trigger()
        #expect(!cooldown.isReady)

        cooldown.update(deltaTime: 0.5)
        #expect(!cooldown.isReady)

        cooldown.update(deltaTime: 0.5)
        #expect(cooldown.isReady)
    }

    @Test("Dice notation")
    func diceNotation() {
        let dice = Dice(notation: "2d6+3")
        #expect(dice != nil)
        #expect(dice?.count == 2)
        #expect(dice?.sides == 6)
        #expect(dice?.modifier == 3)
        #expect(dice?.minimum == 5)
        #expect(dice?.maximum == 15)
    }
}
