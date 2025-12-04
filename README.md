# Game

[![macOS](https://img.shields.io/github/actions/workflow/status/CorvidLabs/swift-game/macOS.yml?label=macOS&branch=main)](https://github.com/CorvidLabs/swift-game/actions/workflows/macOS.yml)
[![ubuntu](https://img.shields.io/github/actions/workflow/status/CorvidLabs/swift-game/ubuntu.yml?label=ubuntu&branch=main)](https://github.com/CorvidLabs/swift-game/actions/workflows/ubuntu.yml)
[![License](https://img.shields.io/github/license/CorvidLabs/swift-game)](https://github.com/CorvidLabs/swift-game/blob/main/LICENSE)
[![Version](https://img.shields.io/github/v/release/CorvidLabs/swift-game)](https://github.com/CorvidLabs/swift-game/releases)

> **Pre-1.0 Notice**: This library is under active development. The API may change between minor versions until 1.0.

A comprehensive, protocol-oriented game development library for Swift 6.

## What is Game?

Game provides essential building blocks for game development in pure Swift. Built with strict concurrency in mind, all public types conform to `Sendable` and work seamlessly across platforms. The library includes math primitives, collision detection, spatial partitioning, state machines, timers, pathfinding, an entity-component system, random number generation, and tweening.

## Requirements

- **Swift** 6.0+
- **Platforms**
  - iOS 16+
  - macOS 13+
  - tvOS 16+
  - watchOS 9+
  - visionOS 1+

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/CorvidLabs/swift-game.git", from: "0.1.0")
]
```

## Usage

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

## Documentation

Documentation is available on [GitHub Pages](https://CorvidLabs.github.io/swift-game/documentation/game).

## Contributing

If you have improvements or issues, feel free to open an issue or pull request!

## License

See [LICENSE](LICENSE)
