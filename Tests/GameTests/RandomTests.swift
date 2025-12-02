import Testing
@testable import Game

@Suite("Random Tests")
struct RandomTests {
    // MARK: - GameRandom Tests

    @Test("GameRandom seeded determinism")
    func gameRandomSeededDeterminism() {
        var rng1 = GameRandom(seed: 12345)
        var rng2 = GameRandom(seed: 12345)

        for _ in 0..<10 {
            #expect(rng1.nextUInt64() == rng2.nextUInt64())
        }
    }

    @Test("GameRandom different seeds")
    func gameRandomDifferentSeeds() {
        var rng1 = GameRandom(seed: 12345)
        var rng2 = GameRandom(seed: 67890)

        #expect(rng1.nextUInt64() != rng2.nextUInt64())
    }

    @Test("GameRandom double range")
    func gameRandomDoubleRange() {
        var rng = GameRandom(seed: 42)

        for _ in 0..<100 {
            let value = rng.nextDouble()
            #expect(value >= 0.0 && value < 1.0)
        }
    }

    @Test("GameRandom double in range")
    func gameRandomDoubleInRange() {
        var rng = GameRandom(seed: 42)

        for _ in 0..<100 {
            let value = rng.nextDouble(in: 10.0...20.0)
            #expect(value >= 10.0 && value <= 20.0)
        }
    }

    @Test("GameRandom int upper bound")
    func gameRandomIntUpperBound() {
        var rng = GameRandom(seed: 42)

        for _ in 0..<100 {
            let value = rng.nextInt(upperBound: 10)
            #expect(value >= 0 && value < 10)
        }
    }

    @Test("GameRandom int in range")
    func gameRandomIntInRange() {
        var rng = GameRandom(seed: 42)

        for _ in 0..<100 {
            let value = rng.nextInt(in: 5...15)
            #expect(value >= 5 && value <= 15)
        }
    }

    @Test("GameRandom bool")
    func gameRandomBool() {
        var rng = GameRandom(seed: 42)

        var trueCount = 0
        var falseCount = 0

        for _ in 0..<100 {
            if rng.nextBool() {
                trueCount += 1
            } else {
                falseCount += 1
            }
        }

        #expect(trueCount > 0)
        #expect(falseCount > 0)
    }

    @Test("GameRandom bool with probability")
    func gameRandomBoolWithProbability() {
        var rng = GameRandom(seed: 42)

        var trueCount = 0
        for _ in 0..<1000 {
            if rng.nextBool(probability: 0.7) {
                trueCount += 1
            }
        }

        // Should be roughly 70%
        #expect(trueCount > 600 && trueCount < 800)
    }

    @Test("GameRandom element from array")
    func gameRandomElementFromArray() {
        var rng = GameRandom(seed: 42)
        let array = [1, 2, 3, 4, 5]

        for _ in 0..<10 {
            let element = rng.nextElement(from: array)
            #expect(element != nil)
            #expect(array.contains(element!))
        }

        let emptyElement = rng.nextElement(from: [Int]())
        #expect(emptyElement == nil)
    }

    @Test("GameRandom shuffle determinism")
    func gameRandomShuffleDeterminism() {
        var rng1 = GameRandom(seed: 42)
        var rng2 = GameRandom(seed: 42)

        var array1 = [1, 2, 3, 4, 5]
        var array2 = [1, 2, 3, 4, 5]

        rng1.shuffle(&array1)
        rng2.shuffle(&array2)

        #expect(array1 == array2)
    }

    @Test("GameRandom shuffled")
    func gameRandomShuffled() {
        var rng = GameRandom(seed: 42)
        let original = [1, 2, 3, 4, 5]

        let shuffled = rng.shuffled(original)

        #expect(shuffled.count == original.count)
        #expect(shuffled.sorted() == original.sorted())
    }

    @Test("GameRandom Vec2")
    func gameRandomVec2() {
        var rng = GameRandom(seed: 42)

        for _ in 0..<10 {
            let vec = rng.nextVec2()
            #expect(vec.x >= 0 && vec.x <= 1)
            #expect(vec.y >= 0 && vec.y <= 1)
        }

        let rangedVec = rng.nextVec2(xRange: 10...20, yRange: 30...40)
        #expect(rangedVec.x >= 10 && rangedVec.x <= 20)
        #expect(rangedVec.y >= 30 && rangedVec.y <= 40)
    }

    @Test("GameRandom direction")
    func gameRandomDirection() {
        var rng = GameRandom(seed: 42)

        for _ in 0..<10 {
            let direction = rng.nextDirection2D()
            #expect(abs(direction.magnitude - 1.0) < 0.0001)
        }
    }

    // MARK: - Dice Tests

    @Test("Dice creation")
    func diceCreation() {
        let dice = Dice(count: 2, sides: 6, modifier: 3)

        #expect(dice.count == 2)
        #expect(dice.sides == 6)
        #expect(dice.modifier == 3)
    }

    @Test("Dice notation parsing")
    func diceNotationParsing() {
        let d6 = Dice(notation: "1d6")
        #expect(d6 != nil)
        #expect(d6?.count == 1)
        #expect(d6?.sides == 6)
        #expect(d6?.modifier == 0)

        let twoD6Plus3 = Dice(notation: "2d6+3")
        #expect(twoD6Plus3 != nil)
        #expect(twoD6Plus3?.count == 2)
        #expect(twoD6Plus3?.sides == 6)
        #expect(twoD6Plus3?.modifier == 3)

        let threeD8Minus2 = Dice(notation: "3d8-2")
        #expect(threeD8Minus2 != nil)
        #expect(threeD8Minus2?.count == 3)
        #expect(threeD8Minus2?.sides == 8)
        #expect(threeD8Minus2?.modifier == -2)
    }

    @Test("Dice min max average")
    func diceMinMaxAverage() {
        let dice = Dice(count: 2, sides: 6, modifier: 3)

        #expect(dice.minimum == 5)
        #expect(dice.maximum == 15)
        #expect(dice.average == 10.0)
    }

    @Test("Dice roll determinism")
    func diceRollDeterminism() {
        var rng1 = GameRandom(seed: 42)
        var rng2 = GameRandom(seed: 42)

        let dice = Dice.d20

        for _ in 0..<10 {
            #expect(dice.roll(using: &rng1) == dice.roll(using: &rng2))
        }
    }

    @Test("Dice roll range")
    func diceRollRange() {
        var rng = GameRandom(seed: 42)
        let dice = Dice(count: 2, sides: 6, modifier: 3)

        for _ in 0..<100 {
            let roll = dice.roll(using: &rng)
            #expect(roll >= dice.minimum && roll <= dice.maximum)
        }
    }

    @Test("Dice presets")
    func dicePresets() {
        #expect(Dice.d6.count == 1)
        #expect(Dice.d6.sides == 6)

        #expect(Dice.d20.count == 1)
        #expect(Dice.d20.sides == 20)

        #expect(Dice.twod6.count == 2)
        #expect(Dice.twod6.sides == 6)
    }

    @Test("Dice description")
    func diceDescription() {
        #expect(Dice(count: 1, sides: 6).description == "1d6")
        #expect(Dice(count: 2, sides: 6, modifier: 3).description == "2d6+3")
        #expect(Dice(count: 3, sides: 8, modifier: -2).description == "3d8-2")
    }

    // MARK: - WeightedRandom Tests

    @Test("WeightedRandom selection")
    func weightedRandomSelection() {
        var rng = GameRandom(seed: 42)

        let weighted = WeightedRandom(items: [
            (element: "common", weight: 70.0),
            (element: "uncommon", weight: 20.0),
            (element: "rare", weight: 10.0)
        ])

        var counts: [String: Int] = [:]

        for _ in 0..<1000 {
            if let item = weighted.select(using: &rng) {
                counts[item, default: 0] += 1
            }
        }

        #expect(counts["common"]! > counts["uncommon"]!)
        #expect(counts["uncommon"]! > counts["rare"]!)
    }

    @Test("WeightedRandom determinism")
    func weightedRandomDeterminism() {
        var rng1 = GameRandom(seed: 42)
        var rng2 = GameRandom(seed: 42)

        let weighted = WeightedRandom(items: [
            (element: "a", weight: 1.0),
            (element: "b", weight: 1.0),
            (element: "c", weight: 1.0)
        ])

        for _ in 0..<10 {
            #expect(weighted.select(using: &rng1) == weighted.select(using: &rng2))
        }
    }

    @Test("WeightedRandom multiple selection")
    func weightedRandomMultipleSelection() {
        var rng = GameRandom(seed: 42)

        let weighted = WeightedRandom(items: [
            (element: "a", weight: 1.0),
            (element: "b", weight: 1.0),
            (element: "c", weight: 1.0)
        ])

        let selected = weighted.select(count: 5, using: &rng)
        #expect(selected.count == 5)
    }

    @Test("WeightedRandom unique selection")
    func weightedRandomUniqueSelection() {
        var rng = GameRandom(seed: 42)

        let weighted = WeightedRandom(items: [
            (element: "a", weight: 1.0),
            (element: "b", weight: 1.0),
            (element: "c", weight: 1.0)
        ])

        let selected = weighted.selectUnique(count: 2, using: &rng)
        #expect(selected.count == 2)
        #expect(selected[0] != selected[1])

        let allThree = weighted.selectUnique(count: 5, using: &rng)
        #expect(allThree.count == 3)
    }

    @Test("WeightedRandom empty")
    func weightedRandomEmpty() {
        var rng = GameRandom(seed: 42)

        let weighted = WeightedRandom(items: [(element: "", weight: 0.0)].filter { $0.weight > 0 })

        #expect(weighted.isEmpty)
        #expect(weighted.count == 0)
        #expect(weighted.select(using: &rng) == nil)
    }

    @Test("WeightedRandom properties")
    func weightedRandomProperties() {
        let weighted = WeightedRandom(items: [
            (element: "a", weight: 1.0),
            (element: "b", weight: 2.0),
            (element: "c", weight: 3.0)
        ])

        #expect(!weighted.isEmpty)
        #expect(weighted.count == 3)
    }
}
