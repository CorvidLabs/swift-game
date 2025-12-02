# swift-game Examples

Comprehensive examples demonstrating the capabilities of the swift-game library.

## Math Examples

### Vector Operations
```swift
import Game

// Create vectors
let position = Vec2(x: 10, y: 20)
let velocity = Vec2(x: 5, y: -3)

// Arithmetic
let newPosition = position + velocity * 2.0
print(newPosition) // Vec2(x: 20, y: 14)

// Magnitude and normalization
let direction = Vec2(x: 3, y: 4)
print(direction.magnitude) // 5.0
let normalized = direction.normalized()
print(normalized.magnitude) // 1.0

// Dot and cross products
let a = Vec2(x: 1, y: 0)
let b = Vec2(x: 0, y: 1)
print(a.dot(b)) // 0.0
print(a.cross(b)) // 1.0

// Rotation
let right = Vec2.right
let up = right.rotated(by: .pi / 2)
```

### Interpolation
```swift
// Linear interpolation
let start = 0.0
let end = 100.0
let halfway = Interpolation.lerp(from: start, to: end, t: 0.5)
print(halfway) // 50.0

// Smooth interpolation
let smoothed = Interpolation.smoothstep(0.5)
print(smoothed) // 0.5 with smooth curve

// Remapping values
let normalized = Interpolation.remap(
    value: 50,
    fromRange: 0...100,
    toRange: 0...1
)
print(normalized) // 0.5

// Exponential decay
var current = 100.0
let target = 0.0
current = Interpolation.exponentialDecay(
    current: current,
    target: target,
    decay: 5.0,
    deltaTime: 0.1
)
```

### Easing Functions
```swift
let t = 0.5

print(Easing.linear(t))        // 0.5
print(Easing.quadraticIn(t))   // 0.25
print(Easing.quadraticOut(t))  // 0.75
print(Easing.elasticOut(t))    // Bouncy effect
print(Easing.bounceOut(t))     // Bounce effect
```

## Collision Examples

### AABB Collision
```swift
let player = AABB(x: 0, y: 0, width: 32, height: 32)
let obstacle = AABB(x: 20, y: 20, width: 32, height: 32)

if player.intersects(obstacle) {
    let collision = player.collisionResult(with: obstacle)
    if let depth = collision.depth, let normal = collision.normal {
        // Resolve collision
        let resolution = normal * depth
        print("Move by \(resolution) to resolve")
    }
}

// Check point containment
let point = Vec2(x: 10, y: 10)
if player.contains(point) {
    print("Point is inside AABB")
}
```

### Circle Collision
```swift
let ball = Circle(center: Vec2(x: 50, y: 50), radius: 10)
let target = Circle(center: Vec2(x: 60, y: 50), radius: 10)

if ball.intersects(target) {
    let collision = ball.collisionResult(with: target)
    if let contactPoint = collision.contactPoint {
        print("Contact at \(contactPoint)")
    }
}

// Circle vs AABB
let box = AABB(x: 40, y: 40, width: 20, height: 20)
if ball.intersects(box) {
    print("Ball hit box")
}
```

### Raycasting
```swift
let ray = Ray(
    origin: Vec2.zero,
    direction: Vec2.right
)

let obstacle = AABB(x: 10, y: -5, width: 10, height: 10)

let hit = Raycast.cast(ray: ray, aabb: obstacle)
if hit.hit, let distance = hit.distance {
    print("Hit at distance \(distance)")
    if let point = hit.point, let normal = hit.normal {
        print("Contact: \(point), Normal: \(normal)")
    }
}
```

## Spatial Examples

### Grid Operations
```swift
// Create a grid
var grid = Grid2D<Int>(width: 10, height: 10, defaultValue: 0)

// Set values
grid[5, 5] = 1

// Access by coordinate
let coord = GridCoord(x: 5, y: 5)
if let value = grid[coord] {
    print("Value at \(coord): \(value)")
}

// Get neighbors
let neighbors = grid.orthogonalNeighbors(of: coord)
for neighbor in neighbors {
    print("Neighbor: \(neighbor)")
}

// Map operation
let doubled = grid.map { $0 * 2 }
```

### Quadtree
```swift
let bounds = AABB(x: 0, y: 0, width: 100, height: 100)
let quadtree = Quadtree<String>(bounds: bounds, capacity: 4)

// Insert items
quadtree.insert(.init(position: Vec2(x: 10, y: 10), element: "A"))
quadtree.insert(.init(position: Vec2(x: 50, y: 50), element: "B"))
quadtree.insert(.init(position: Vec2(x: 90, y: 90), element: "C"))

// Query region
let searchArea = AABB(x: 0, y: 0, width: 60, height: 60)
let results = quadtree.query(in: searchArea)
print("Found \(results.count) items")

// Find nearest
let point = Vec2(x: 12, y: 12)
if let nearest = quadtree.nearest(to: point) {
    print("Nearest to \(point): \(nearest.element)")
}
```

### Spatial Hash
```swift
var spatialHash = SpatialHash<String>(cellSize: 10.0)

// Insert items
let item1 = SpatialHash.Item(
    bounds: AABB(x: 0, y: 0, width: 5, height: 5),
    element: "Player"
)
spatialHash.insert(item1)

// Query
let searchArea = AABB(x: -5, y: -5, width: 20, height: 20)
let nearby = spatialHash.query(in: searchArea)
for item in nearby {
    print("Found: \(item.element)")
}
```

## Pathfinding Examples

### A* on Navigation Grid
```swift
// Create navigation grid
var navGrid = NavigationGrid(width: 20, height: 20, allowDiagonal: true)

// Block some cells
navGrid.setWalkable(GridCoord(x: 10, y: 10), walkable: false)

// Find path
let start = GridCoord(x: 0, y: 0)
let goal = GridCoord(x: 19, y: 19)

let path = AStar.findPathInGrid(
    in: navGrid,
    from: start,
    to: goal,
    heuristic: Heuristic.euclidean
)

if path.found {
    print("Path found with \(path.length) steps")
    for (index, node) in path.enumerated() {
        print("Step \(index): \(node)")
    }
    print("Total cost: \(path.cost)")
}
```

## State Machine Examples

### Game State Management
```swift
enum GameState: String {
    case menu, playing, paused, gameOver
}

struct MenuState: State {
    func onEnter() {
        print("Entering menu")
    }

    func onExit() {
        print("Leaving menu")
    }
}

struct PlayingState: State {
    func onUpdate(deltaTime: Double) {
        // Game logic
    }
}

let fsm = StateMachine<GameState>(initialState: .menu)
fsm.register(state: .menu, handler: MenuState())
fsm.register(state: .playing, handler: PlayingState())

// Transition callbacks
fsm.onTransition { from, to in
    print("Transitioned from \(from) to \(to)")
}

fsm.transition(to: .playing)
fsm.update(deltaTime: 0.016)
```

## Timer Examples

### Cooldown System
```swift
var dashCooldown = Cooldown(duration: 2.0)

func update(deltaTime: Double) {
    dashCooldown.update(deltaTime: deltaTime)

    if dashCooldown.isReady {
        print("Dash ready! (\(dashCooldown.progress * 100)%)")
    }
}

func tryDash() {
    if dashCooldown.tryTrigger() {
        print("Dashing!")
        // Perform dash
    } else {
        print("Dash on cooldown: \(dashCooldown.remaining)s remaining")
    }
}
```

### Event Scheduling
```swift
let scheduler = Scheduler()

// Schedule one-time event
scheduler.scheduleOnce(after: 1.0) {
    print("This runs after 1 second")
}

// Schedule repeating event
let timerId = scheduler.scheduleRepeating(interval: 0.5) {
    print("This runs every 0.5 seconds")
}

// Update scheduler
scheduler.update(deltaTime: deltaTime)

// Cancel event
scheduler.cancel(timerId)
```

### Fixed Timestep
```swift
var accumulator = TickAccumulator(fixedDeltaTime: 1.0 / 60.0)

func gameLoop(deltaTime: Double) {
    accumulator.update(deltaTime: deltaTime) { fixedDelta in
        // Physics update at fixed 60 FPS
        updatePhysics(deltaTime: fixedDelta)
    }

    // Render with interpolation
    let alpha = accumulator.alpha
    render(interpolation: alpha)
}
```

## Random Examples

### Deterministic Randomness
```swift
var rng = GameRandom(seed: 12345)

// Generate random numbers
let value = rng.nextDouble() // [0, 1)
let inRange = rng.nextDouble(in: 10...20)
let integer = rng.nextInt(in: 1...6)
let boolean = rng.nextBool(probability: 0.3)

// Random vectors
let position = rng.nextVec2(
    xRange: 0...100,
    yRange: 0...100
)

// Random selection
let options = ["Fire", "Water", "Earth", "Air"]
if let element = rng.nextElement(from: options) {
    print("Selected: \(element)")
}

// Shuffle
var deck = Array(1...52)
rng.shuffle(&deck)
```

### Dice Rolling
```swift
var rng = GameRandom()

// Standard dice
let d20 = Dice.d20
print("D20 roll: \(d20.roll(using: &rng))")

// Custom dice
let damage = Dice(count: 2, sides: 6, modifier: 3)
print("Damage: \(damage.roll(using: &rng))")

// Parse notation
if let customDice = Dice(notation: "3d8+2") {
    let rolls = (0..<10).map { _ in customDice.roll(using: &rng) }
    print("10 rolls: \(rolls)")
    print("Average: \(customDice.average)")
}
```

### Weighted Random Selection
```swift
var rng = GameRandom()

let lootTable = WeightedRandom(items: [
    (element: "Common", weight: 70.0),
    (element: "Rare", weight: 25.0),
    (element: "Legendary", weight: 5.0)
])

// Single selection
if let rarity = lootTable.select(using: &rng) {
    print("Dropped: \(rarity)")
}

// Multiple selections
let drops = lootTable.select(count: 10, using: &rng)
print(drops)

// Unique selection
let unique = lootTable.selectUnique(count: 2, using: &rng)
```

### Loot Tables
```swift
var rng = GameRandom()

let treasureChest = LootTable(
    entries: [
        .init(item: "Gold", weight: 50.0, quantity: 10...50),
        .init(item: "Potion", weight: 30.0, quantity: 1...3),
        .init(item: "Gem", weight: 15.0, quantity: 1...2),
        .init(item: "Artifact", weight: 5.0, quantity: 1...1)
    ],
    dropChance: 0.8
)

// Single roll
if let loot = treasureChest.roll(using: &rng) {
    print("Found: \(loot.quantity)x \(loot.item)")
}

// Multiple rolls
let allLoot = treasureChest.roll(count: 5, using: &rng)
for result in allLoot {
    print("\(result.quantity)x \(result.item)")
}
```

## ECS Examples

### Basic ECS Usage
```swift
struct Position: Component {
    var x: Double
    var y: Double
}

struct Velocity: Component {
    var dx: Double
    var dy: Double
}

struct Health: Component {
    var current: Int
    var maximum: Int
}

let world = World()

// Create entities
let player = world.createEntity()
world.addComponent(Position(x: 0, y: 0), to: player)
world.addComponent(Velocity(dx: 1, dy: 0), to: player)
world.addComponent(Health(current: 100, maximum: 100), to: player)

let enemy = world.createEntity()
world.addComponent(Position(x: 50, y: 50), to: enemy)
world.addComponent(Health(current: 50, maximum: 50), to: enemy)

// Query entities
world.query(Position.self, Velocity.self) { entity, pos, vel in
    print("Entity \(entity) at (\(pos.x), \(pos.y)) moving at (\(vel.dx), \(vel.dy))")
}

// Update components
world.updateComponent(Position.self, on: player) { pos in
    pos.x += 10
    pos.y += 5
}

// Check for component
if world.hasComponent(Health.self, on: enemy) {
    if let health = world.getComponent(Health.self, from: enemy) {
        print("Enemy health: \(health.current)/\(health.maximum)")
    }
}
```

## Tweening Examples

### Basic Tweening
```swift
var tween = Tween(
    from: 0.0,
    to: 100.0,
    duration: 2.0,
    easing: Easing.quadraticOut
)

// Update loop
while !tween.completed {
    tween.update(deltaTime: 0.016)
    let currentValue = tween.value
    print("Value: \(currentValue)")
}
```

### Tween Manager
```swift
let tweenManager = TweenManager()

// Tween a position
var position = Vec2.zero
tweenManager.tweenVec2(
    from: Vec2.zero,
    to: Vec2(x: 100, y: 100),
    duration: 1.0,
    easing: Easing.elasticOut
) { newPosition in
    position = newPosition
} onComplete: {
    print("Tween completed!")
}

// Tween multiple values
tweenManager.tweenDouble(
    from: 0,
    to: 360,
    duration: 2.0,
    easing: Easing.linear
) { rotation in
    // Update rotation
}

// Update all tweens
func update(deltaTime: Double) {
    tweenManager.update(deltaTime: deltaTime)
}
```

### Preset Tweens
```swift
let bounceIn = Tween<Vec2>.bounceOut(
    from: Vec2(x: 0, y: 100),
    to: Vec2(x: 100, y: 0),
    duration: 1.5
)

let elasticTween = Tween<Double>.elasticOut(
    from: 1.0,
    to: 2.0,
    duration: 1.0
)
```

## Complete Game Loop Example

```swift
import Game

class GameLoop {
    let world = World()
    let tweenManager = TweenManager()
    let scheduler = Scheduler()
    var accumulator = TickAccumulator(fixedDeltaTime: 1.0 / 60.0)
    var rng = GameRandom(seed: 42)

    func setup() {
        // Create player
        let player = world.createEntity()
        world.addComponent(Position(x: 0, y: 0), to: player)
        world.addComponent(Velocity(dx: 0, dy: 0), to: player)

        // Schedule events
        scheduler.scheduleRepeating(interval: 1.0) {
            self.spawnEnemy()
        }
    }

    func update(deltaTime: Double) {
        // Update timers
        scheduler.update(deltaTime: deltaTime)
        tweenManager.update(deltaTime: deltaTime)

        // Fixed timestep physics
        accumulator.update(deltaTime: deltaTime) { fixedDelta in
            self.updatePhysics(deltaTime: fixedDelta)
        }

        // Update game logic
        updateEntities(deltaTime: deltaTime)
    }

    private func updatePhysics(deltaTime: Double) {
        world.query(Position.self, Velocity.self) { entity, pos, vel in
            world.updateComponent(Position.self, on: entity) { position in
                position.x += vel.dx * deltaTime
                position.y += vel.dy * deltaTime
            }
        }
    }

    private func updateEntities(deltaTime: Double) {
        // Game logic
    }

    private func spawnEnemy() {
        let enemy = world.createEntity()
        let randomPos = rng.nextVec2(
            xRange: 0...100,
            yRange: 0...100
        )
        world.addComponent(
            Position(x: randomPos.x, y: randomPos.y),
            to: enemy
        )
    }
}
```
