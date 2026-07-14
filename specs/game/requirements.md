---
spec: game.spec.md
---

## Requirements

The stable requirements for this existing API are introduced atomically by CHG-0002 after definition approval and successful native verification.

### REQ-game-001

Vector and angle values SHALL preserve their documented construction, arithmetic, normalization, distance, projection, reflection, and interpolation behavior, including safe zero-vector handling.
Acceptance Criteria
- Math tests pass and every exported math symbol is documented.

### REQ-game-002

Interpolation and easing helpers SHALL preserve the documented families, clamping, overshoot, and degenerate-input behavior.
Acceptance Criteria
- Interpolation and easing tests pass.

### REQ-game-003

Collision and ray queries SHALL report boundary-inclusive intersections, detailed hits, closest collection hits, and explicit miss values.
Acceptance Criteria
- All 25 collision tests pass.

### REQ-game-004

World SHALL actor-isolate entity and component storage and expose typed snapshot queries without mutating unknown entities.
Acceptance Criteria
- Public ECS source paths and concurrency boundaries match the companion.

### REQ-game-005

Grid and spatial APIs SHALL provide safe bounds behavior, coordinate operations, and isolated/deduplicated spatial queries.
Acceptance Criteria
- All 18 spatial tests pass; SpatialHash is source-reviewed without a direct-test claim.

### REQ-game-006

AStar and NavigationGrid SHALL return endpoint-inclusive paths with accumulated costs or Path.notFound when unreachable.
Acceptance Criteria
- All 16 pathfinding tests pass.

### REQ-game-007

Seeded random utilities SHALL be deterministic for identical seeds and call order and preserve documented empty/invalid-input behavior.
Acceptance Criteria
- All 26 random tests pass.

### REQ-game-008

LootTable SHALL clamp drop chance and provide weighted, repeated, and combined result operations.
Acceptance Criteria
- LootTable source is reviewed without claiming a direct test that does not exist.

### REQ-game-009

StateMachine SHALL actor-isolate state and order exit, current-state update, enter, and transition notifications deterministically.
Acceptance Criteria
- All nine state-machine tests pass.

### REQ-game-010

Cooldown, TickAccumulator, and Scheduler SHALL advance only through explicit caller updates and preserve documented cancellation and callback behavior.
Acceptance Criteria
- Timer tests pass; scheduler-specific behavior is source-reviewed.

### REQ-game-011

Tween and TweenManager SHALL preserve typed interpolation, lifecycle control, actor isolation, and completion ordering.
Acceptance Criteria
- All 22 tween value tests pass; manager behavior is source-reviewed.

### REQ-game-012

The Game product SHALL retain sendable public values, actor-isolated shared coordinators, no hidden background loop, and no runtime dependency beyond Foundation and Swift.
Acceptance Criteria
- Native build, 157 tests, and exact-head Trust pass with Sources, Tests, and Package.swift unchanged.

