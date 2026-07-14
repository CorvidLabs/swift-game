---
spec: game.spec.md
---

## Automated Testing

| Test file | Tests | Requirements | Implemented behavior exercised |
|-----------|------:|--------------|--------------------------------|
| `Tests/GameTests/MathTests.swift` | 27 | REQ-game-001, REQ-game-002 | Vec2/Vec3 arithmetic, magnitude, normalization, products, distance, rotation, projection, angle conversion/normalization/difference/lerp, easing boundaries, and interpolation helpers. |
| `Tests/GameTests/CollisionTests.swift` | 25 | REQ-game-003 | AABB/circle construction, containment, intersection, closest points, penetration results, ray construction/distances, detailed raycasts, and closest collection hit. |
| `Tests/GameTests/GameTests.swift` | 4 | REQ-game-001, REQ-game-010 | Basic vector, grid-coordinate, cooldown, and fixed-step behavior. |
| `Tests/GameTests/PathfindingTests.swift` | 16 | REQ-game-005, REQ-game-006 | Navigation-grid creation/walkability/neighbors/cost, Manhattan/Euclidean A*, obstacles, diagonals, same endpoint, no path, complex maze, and `Path` collection behavior. |
| `Tests/GameTests/RandomTests.swift` | 26 | REQ-game-007, REQ-game-008 | Seed determinism, numeric/bool/element/vector/direction/shuffle helpers, dice parsing/ranges/presets/description, weighted selection/replacement/unique/empty behavior. Loot APIs are source-reviewed because this file contains no direct loot-table test. |
| `Tests/GameTests/SpatialTests.swift` | 18 | REQ-game-005 | GridCoord operations/conversions, Grid2D bounds/subscripts/neighbors/generation/filter/map, and quadtree insertion, subdivision, range/radius/nearest queries, clear, and out-of-bounds rejection. SpatialHash is source-reviewed because this file contains no direct spatial-hash test. |
| `Tests/GameTests/StateMachineTests.swift` | 9 | REQ-game-009, REQ-game-012 | Initialization, state registration, transitions, callbacks, same-state behavior, update forwarding, queries, and multi-step flows. |
| `Tests/GameTests/TimerTests.swift` | 10 | REQ-game-010 | Cooldown initialization/update/trigger/reset/progress/remaining/zero-duration/multiple-cycle behavior. Scheduler and TickAccumulator details beyond the basic suite are source-reviewed. |
| `Tests/GameTests/TweeningTests.swift` | 22 | REQ-game-001, REQ-game-002, REQ-game-011 | Double/Float/Vec2/Angle tweenability, creation/update/progress/completion/reset/seek/reverse, zero/negative/equal endpoints, over-update, and easing presets. TweenManager is source-reviewed because this file directly tests value tweens, not manager callbacks. |

The native command is `fledge lanes run verify`, which runs `swift build` and `swift test`. The observed baseline is 157 passing tests in nine suites. No direct test exists for every exported convenience API; uncovered surfaces are explicitly identified above and are not presented as executed evidence.

## Hosted Validation

- Existing `macOS` workflow: Swift build and tests on `macos-latest` for product changes.
- Existing `ubuntu` workflow: Swift 6 container build and tests for product changes.
- Existing `Documentation` workflow: DocC generation and Pages deployment on main for source/package changes.
- Existing `CodeQL` workflow: Actions and Swift analysis.
- Added `trust` job: every pull request and main push, full-history checkout, immutable Trust 1.0.0 action.

## Edge Cases and Boundary Conditions

| Scenario | Expected behavior |
|----------|-------------------|
| Zero vector normalization/projection | Return zero vector. |
| Shape tangency | Counts as collision/intersection with zero penetration where applicable. |
| Invalid grid access | Optional read is `nil`; write is ignored. |
| Unreachable path | Empty, infinite-cost `Path.notFound`. |
| Empty random collection or non-positive total weight | No selected value. |
| Invalid dice notation | Failable initializer returns `nil`. |
| Same-state transition | No exit, enter, or transition callback. |
| Over-updated cooldown/tween | Public remaining/progress/value stays at its terminal boundary. |
| Non-positive repeat/ping-pong length | Returns zero. |

## Manual Review

- Confirm the companion names all 35 exact-case `Sources/Game` paths and every parser-visible export.
- Confirm `git diff origin/main...HEAD -- Sources Tests Package.swift` is empty.
- Confirm every artifact contains final substantive content and no fabricated result or early hosted-success claim before lifecycle acceptance.
