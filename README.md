# swift-game

A comprehensive, protocol-oriented game development library for Swift 6.

## Overview

`swift-game` provides essential building blocks for game development in pure Swift. Built with strict concurrency in mind, all public types conform to `Sendable` and work seamlessly across platforms.

## Features

### Math
- **Vec2** & **Vec3**: Full-featured vectors with arithmetic, dot/cross products, normalization
- **Angle**: Type-safe angle handling with degrees/radians conversion
- **Interpolation**: lerp, inverseLerp, remap, smoothstep, smootherstep, exponential decay, spring
- **Easing**: 30+ easing functions (linear, quadratic, cubic, sine, exponential, elastic, bounce, back)

### Collision
- **AABB**: Axis-aligned bounding box collision detection
- **Circle**: Circle collision with AABBs and other circles
- **Ray** & **Raycast**: Full raycasting system with hit detection

### Spatial
- **GridCoord**: Discrete 2D grid coordinates with neighbor queries
- **Grid2D**: Generic 2D grid data structure with mapping and queries
- **Quadtree**: Spatial partitioning for efficient range queries
- **SpatialHash**: Hash-based spatial partitioning for broad-phase collision

### State Machine
- **State**: Protocol-based state definitions
- **StateMachine**: Generic finite state machine with transition callbacks

### Timers
- **Cooldown**: Action cooldown management
- **Scheduler**: Event scheduling with one-shot and repeating timers
- **TickAccumulator**: Fixed timestep accumulator for physics

### Pathfinding
- **Graph**: Protocol for pathfinding graphs
- **NavigationGrid**: Grid-based navigation with walkability
- **AStar**: A* pathfinding with customizable heuristics
- **Heuristic**: Manhattan, Euclidean, Chebyshev, Octile distance functions

### ECS (Entity Component System)
- **Entity**: Unique entity identifiers
- **Component**: Protocol for data-only components
- **World**: Entity-component storage with powerful queries

### Random
- **GameRandom**: Seedable PRNG (xorshift128+) for deterministic randomness
- **Dice**: RPG dice notation parsing and rolling (2d6+3)
- **WeightedRandom**: Weighted random selection
- **LootTable**: Loot generation with drop chances

### Tweening
- **Tweenable**: Protocol for types that can be animated
- **Tween**: Single value animation with easing
- **TweenManager**: Manage multiple concurrent tweens

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/0xLeif/swift-game.git", from: "0.1.0")
]
```

## Usage Examples

### Vector Math
```swift
let v1 = Vec2(x: 3, y: 4)
let magnitude = v1.magnitude // 5.0
let normalized = v1.normalized()
let rotated = v1.rotated(by: .pi / 2)
```

### Collision Detection
```swift
let box1 = AABB(x: 0, y: 0, width: 10, height: 10)
let box2 = AABB(x: 5, y: 5, width: 10, height: 10)

if box1.intersects(box2) {
    let result = box1.collisionResult(with: box2)
    print("Collision depth: \(result.depth ?? 0)")
}
```

### Pathfinding
```swift
let grid = NavigationGrid(width: 10, height: 10)
let start = GridCoord(x: 0, y: 0)
let goal = GridCoord(x: 9, y: 9)

let path = AStar.findPathInGrid(in: grid, from: start, to: goal)
if path.found {
    print("Path length: \(path.length)")
}
```

### State Machine
```swift
enum GameState: String {
    case menu, playing, paused, gameOver
}

let fsm = StateMachine<GameState>(initialState: .menu)
fsm.register(state: .playing, handler: PlayingState())
fsm.transition(to: .playing)
```

### Dice Rolling
```swift
var random = GameRandom(seed: 12345)

// Parse dice notation
let dice = Dice(notation: "2d6+3")!
let roll = dice.roll(using: &random)
print("Rolled: \(roll)") // 5-15
```

### Tweening
```swift
let tweenManager = TweenManager()

tweenManager.tweenVec2(
    from: Vec2.zero,
    to: Vec2(x: 100, y: 100),
    duration: 1.0,
    easing: Easing.quadraticOut
) { position in
    // Update position
}

tweenManager.update(deltaTime: deltaTime)
```

### ECS
```swift
struct Position: Component {
    var x: Double
    var y: Double
}

struct Velocity: Component {
    var dx: Double
    var dy: Double
}

let world = World()
let entity = world.createEntity()

world.addComponent(Position(x: 0, y: 0), to: entity)
world.addComponent(Velocity(dx: 1, dy: 1), to: entity)

// Query entities
world.query(Position.self, Velocity.self) { entity, pos, vel in
    // Update logic
}
```

## Platform Support

- iOS 15+
- macOS 12+
- tvOS 15+
- watchOS 8+
- visionOS 1+

## Swift Version

Requires Swift 6.0 or later with strict concurrency enabled.

## License

MIT License - feel free to use in your projects!
