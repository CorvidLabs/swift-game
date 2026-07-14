---
change: CHG-0002-document-the-complete-existing-swift-game-api-and-behavior-for-specsync-5-0-1
artifact: research
---

# Research

- Inventory: 35 `Sources/Game` files, 3,352 source lines, nine `Tests/GameTests` files, and 157 `@Test` cases in nine suites.
- Public boundaries: math/collision values, actor-isolated ECS and runtime coordinators, pathfinding, seedable random utilities, spatial indices, timers, state transitions, and typed tweening.
- Runtime dependencies: Swift standard library and Foundation. `swift-docc-plugin` is build-time documentation tooling only.
- Existing workflows: macOS build/tests, Ubuntu Swift 6 build/tests, DocC Pages, and CodeQL. These remain independent and unchanged.
- Failure conventions: implemented APIs primarily return optionals, booleans, empty results, or sentinels. The exported `GameError` cases are not falsely described as thrown where source does not throw.
