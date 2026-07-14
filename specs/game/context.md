---
spec: game.spec.md
---

## Key Decisions

- The package remains a single `Game` library target. The companion groups its public contract by capability without inventing source modules that do not exist.
- Deterministic value types are structs/enums; mutable shared coordinators are actors. Callers own update-loop timing.
- Failure behavior remains the implemented mix of optionals, booleans, empty collections, and sentinel results. The exported `GameError` vocabulary is documented but is not falsely described as thrown by APIs that do not throw.
- The migration sets contract coverage to 100% and changes governance/specification files only. `Sources/`, `Tests/`, and `Package.swift` remain byte-for-byte unchanged.

## Files to Read First

- `Package.swift` for the product, supported Apple platforms, and DocC-only dependency.
- `Sources/Game/Math/Vec2.swift` and `Sources/Game/Math/Angle.swift` for value-type conventions.
- `Sources/Game/ECS/World.swift` and `Sources/Game/Tweening/TweenManager.swift` for actor isolation.
- `Sources/Game/Pathfinding/AStar.swift`, `Sources/Game/Pathfinding/NavigationGrid.swift`, and `Sources/Game/Pathfinding/Path.swift` for graph search behavior.
- `Tests/GameTests/` for 157 deterministic examples across nine suites.

## Current Status

- The existing implementation covers 35 Swift source files and 3,352 lines.
- Native verification builds successfully and passes 157 tests in nine suites on macOS.
- Existing Ubuntu Swift 6, macOS, CodeQL, and DocC Pages workflows remain independent of the unified Trust gate.

## Known Boundaries

- There is no renderer, physics engine, persistence layer, networking stack, input system, audio system, or autonomous game loop.
- The test suite is deterministic and does not exercise performance limits or long-running real-time scheduling.
- Linux compatibility is exercised by the existing Ubuntu workflow; the package manifest declares Apple deployment targets and does not declare Windows-specific validation.
