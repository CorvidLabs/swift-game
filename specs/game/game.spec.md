---
module: game
version: 2
status: active
files:
  - Sources/Game/Collision/AABB.swift
  - Sources/Game/Collision/Circle.swift
  - Sources/Game/Collision/CollisionResult.swift
  - Sources/Game/Collision/Ray.swift
  - Sources/Game/Collision/Raycast.swift
  - Sources/Game/ECS/Component.swift
  - Sources/Game/ECS/Entity.swift
  - Sources/Game/ECS/World.swift
  - Sources/Game/GameError.swift
  - Sources/Game/Math/Angle.swift
  - Sources/Game/Math/Easing.swift
  - Sources/Game/Math/Interpolation.swift
  - Sources/Game/Math/Vec2.swift
  - Sources/Game/Math/Vec3.swift
  - Sources/Game/Pathfinding/AStar.swift
  - Sources/Game/Pathfinding/Graph.swift
  - Sources/Game/Pathfinding/Heuristic.swift
  - Sources/Game/Pathfinding/NavigationGrid.swift
  - Sources/Game/Pathfinding/Path.swift
  - Sources/Game/Random/Dice.swift
  - Sources/Game/Random/GameRandom.swift
  - Sources/Game/Random/LootTable.swift
  - Sources/Game/Random/WeightedRandom.swift
  - Sources/Game/Spatial/Grid2D.swift
  - Sources/Game/Spatial/GridCoord.swift
  - Sources/Game/Spatial/Quadtree.swift
  - Sources/Game/Spatial/SpatialHash.swift
  - Sources/Game/StateMachine/State.swift
  - Sources/Game/StateMachine/StateMachine.swift
  - Sources/Game/Timers/Cooldown.swift
  - Sources/Game/Timers/Scheduler.swift
  - Sources/Game/Timers/TickAccumulator.swift
  - Sources/Game/Tweening/Tween.swift
  - Sources/Game/Tweening/TweenManager.swift
  - Sources/Game/Tweening/Tweenable.swift
db_tables: []
depends_on: []
---

# Game

## Purpose

`Game` is a dependency-light Swift library of deterministic building blocks for games. It owns value-based math and collision primitives, actor-isolated ECS and runtime coordinators, grid and spatial queries, A* pathfinding, seedable random selection, fixed-step timers, finite-state transitions, and typed tweening. It does not own rendering, physics integration, persistence, networking, input, audio, or a game loop; callers choose when to call update methods and how to consume results.

## Public API

### Public Math Types

| Type | Public surface and behavior |
|------|-----------------------------|
| `Angle` | Stores `radians`; constructs with `radians(_:)` or `degrees(_:)`; exposes `degrees`, `zero`, `quarter`, `half`, `threeQuarters`, `full`, `normalized()`, `normalizedSigned()`, `difference(to:)`, and shortest-path `lerp(to:t:)`. It supports `+`, `-`, `*`, `/`, prefix negation, `+=`, `-=`, `*=`, `/=`, and `<`. |
| `Vec2` | Immutable `x`/`y` vector with `zero`, `right`, `up`, `left`, `down`, and `one`; exposes `magnitude`, `magnitudeSquared`, `normalized()`, `dot(_:)`, `cross(_:)`, `distance(to:)`, `distanceSquared(to:)`, `angle`, `perpendicular`, `rotated(by:)`, `absolute`, `clamped(min:max:)`, `fromAngle(_:magnitude:)`, `reflected(across:)`, `projected(onto:)`, and `lerp(to:t:)`. It supports `+`, `-`, `*`, `/`, prefix negation, `+=`, `-=`, `*=`, and `/=`. |
| `Vec3` | Immutable `x`/`y`/`z` vector with `zero`, `right`, `up`, `forward`, `left`, `down`, `back`, and `one`; exposes `magnitude`, `magnitudeSquared`, `normalized()`, `dot(_:)`, `cross(_:)`, `distance(to:)`, `distanceSquared(to:)`, `absolute`, `clamped(min:max:)`, `reflected(across:)`, `projected(onto:)`, `lerp(to:t:)`, `xy`, and `xz`. It supports `+`, `-`, `*`, `/`, prefix negation, `+=`, `-=`, `*=`, and `/=`. |
| `Easing` | Stateless easing namespace: `linear`, `quadraticIn`, `quadraticOut`, `quadraticInOut`, `cubicIn`, `cubicOut`, `cubicInOut`, `quarticIn`, `quarticOut`, `quarticInOut`, `quinticIn`, `quinticOut`, `quinticInOut`, `sineIn`, `sineOut`, `sineInOut`, `exponentialIn`, `exponentialOut`, `exponentialInOut`, `circularIn`, `circularOut`, `circularInOut`, `elasticIn`, `elasticOut`, `elasticInOut`, `backIn`, `backOut`, `backInOut`, `bounceIn`, `bounceOut`, and `bounceInOut`. Inputs are intended to be normalized progress values; overshooting families may return values outside 0...1. |
| `Interpolation` | Stateless helpers `lerp`, `inverseLerp`, `remap`, `smoothstep`, `smootherstep`, `clamp`, `clamp01`, `moveTowards`, `exponentialDecay`, `spring`, `pingPong`, and `repeat`. Smooth-step inputs are clamped; `inverseLerp` returns zero for an equal range; `pingPong` and `repeat` return zero for non-positive length. |

### Public Collision Types

| Type | Public surface and behavior |
|------|-----------------------------|
| `AABB` | Axis-aligned box defined by `min` and `max`, or constructed from `center`/`size` or `x`/`y`/`width`/`height`. Derived values are `center`, `size`, `width`, `height`, and `extents`. Queries and transforms are `contains`, `intersects`, `collisionResult`, `closestPoint`, `expanded`, `union`, and optional `intersection`. Boundary contact counts as containment/intersection. |
| `Circle` | Circle with `center`, `radius`, `diameter`, and `area`; supports point/circle `contains`, circle/AABB `intersects`, `collisionResult` overloads, and `closestPoint`. Tangency counts as intersection. |
| `CollisionResult` | Immutable result with `collided`, optional `contactPoint`, optional `normal`, and optional `depth`; offers `noCollision` and `collision(at:normal:depth:)`. |
| `Ray` | Stores `origin` and a normalized `direction`; `towards(origin:target:)` constructs a directed ray, `point(at:)` samples it, and `cast(circle:maxDistance:)` / `cast(aabb:maxDistance:)` return the first non-negative hit distance within the limit or `nil`. |
| `RaycastHit` | Detailed result with `hit`, optional `distance`, optional `point`, and optional `normal`; offers `noHit` and `hit(distance:point:normal:)`. |
| `Raycast` | `cast` overloads return detailed hits for one circle, one AABB, arrays of circles, or arrays of AABBs; collection overloads retain the closest hit within `maxDistance`. |

### Public ECS and State Types

| Type | Public surface and behavior |
|------|-----------------------------|
| `Component` | Marker protocol requiring `Sendable`. |
| `Entity` | `Sendable`, hashable, codable UUID identity with `id`, `init(id:)`, `create()`, and textual `description`. |
| `World` | Actor-isolated entity/component store. `createEntity`, `destroyEntity`, and `hasEntity` manage identity; `addComponent`, `removeComponent`, `getComponent`, `hasComponent`, and `updateComponent` manage typed components; `entitiesWith`, two- and three-component `entitiesWithAll`, one- and two-component `query`, `entityCount`, and `clear` expose deterministic snapshots. Component writes for unknown entities are ignored. |
| `State` | `Sendable` callback protocol with `onEnter`, `onUpdate(deltaTime:)`, and `onExit`; public defaults make every callback optional to implement. |
| `StateMachine` | Actor keyed by a hashable/sendable state value. It exposes nested `TransitionCallback`, `current`, `init(initialState:)`, single and bulk `register`, `transition`, `update`, `onTransition`, `isInState`, and `isInAnyState`. A transition to the current value is a no-op; a real transition calls old `onExit`, updates `current`, calls new `onEnter`, then notifies callbacks in registration order. |

### Public Grid, Spatial, and Pathfinding Types

| Type | Public surface and behavior |
|------|-----------------------------|
| `GridCoord` | Integer `x`/`y` coordinate with `zero`, `right`, `up`, `left`, `down`, `orthogonalNeighbors`, `diagonalNeighbors`, `allNeighbors`, `manhattanDistance`, `chebyshevDistance`, `euclideanDistance`, `toWorldPosition`, `fromWorldPosition`, arithmetic `+`, `-`, `*`, and lexicographic `<`. |
| `Grid2D` | Sendable row-major grid with `width`, `height`, default-value and coordinate-generator initializers, `isValid`, optional coordinate and `x`/`y` subscripts, `orthogonalNeighbors`, `allNeighbors`, `allCoordinates`, `map`, filtered `coordinates`, region `fill`, optional `subgrid`, conditional `==`, and `hash(into:)`. Out-of-range reads return `nil`; out-of-range writes are ignored. |
| `Quadtree` | Actor-isolated point index with nested `Item(position:element:)`, `init(bounds:capacity:)`, asynchronous `insert`, range/radius `query`, `nearest`, and `clear`. Insertion outside the root bounds returns `false`; query results are snapshots. |
| `SpatialHash` | Mutable hash-grid index with nested hashable `Item(bounds:element:)`, `init(cellSize:)`, `insert`, `remove`, bounds/radius `query`, `clear`, and `update(_:newBounds:)`. Query results are deduplicated `Set` values. |
| `Graph` | Sendable protocol with hashable/sendable associated `Node`, `neighbors(of:)`, and edge `cost(from:to:)`. |
| `NavigationGrid` | Boolean walkability grid with initializers from `Grid2D<Bool>` or dimensions, `width`, `height`, `isWalkable`, `isValid`, `setWalkable`, graph `neighbors`, and movement `cost`. Optional diagonal movement changes both neighbor generation and diagonal cost. |
| `Heuristic` | Grid heuristics `manhattan`, `euclidean`, `chebyshev`, `octile`, and `zero`. |
| `Path` | Sendable path result with `nodes`, `cost`, `found`, `length`, optional `start`, optional `goal`, and `notFound`; conditionally `Equatable` and a `Collection` with `startIndex`, `endIndex`, positional subscript, and `index(after:)`. |
| `AStar` | `findPath` searches any `Graph` using a caller-supplied heuristic; `findPathInGrid` selects Manhattan or octile behavior from the grid's diagonal policy. Start equal to goal returns a one-node path; an unreachable goal returns `Path.notFound`. |

### Public Random and Loot Types

| Type | Public surface and behavior |
|------|-----------------------------|
| `GameRandom` | Seedable xorshift128+ generator. `init(seed:)` is deterministic (including a defined nonzero fallback for seed zero), while `init()` uses current time. Mutation APIs are `nextUInt64`, `nextDouble` (unit/range), `nextFloat` (unit/range), `nextInt` (upper bound/range), `nextBool`, `nextElement`, `shuffle`, `shuffled`, `nextVec2`, `nextVec3`, `nextAngle`, `nextDirection2D`, and `nextGridCoord`. Empty element selection returns `nil`; a non-positive integer upper bound returns zero. |
| `Dice` | RPG dice value with `count`, `sides`, `modifier`, direct and failable notation initializers, `roll`, `minimum`, `maximum`, `average`, presets `d4`, `d6`, `d8`, `d10`, `d12`, `d20`, `d100`, `twod6`, `threed6`, and canonical `description`. Notation accepts case-insensitive `NdS`, optionally followed by a signed modifier. |
| `WeightedRandom` | Selector with nested `WeightedItem(element:weight:)`, initializers for item values or labeled tuples, `select`, replacement `select(count:)`, non-replacement `selectUnique`, `count`, and `isEmpty`. Empty or non-positive-total collections select no value. |
| `LootTable` | Weighted drop model with nested `Entry(item:weight:quantity:)` and `LootResult(item:quantity:)`; exposes `init(entries:dropChance:)`, `roll`, repeated `roll(count:)`, hashable-item `rollCombined`, `guaranteed`, and `rare`. Drop chance is clamped to 0...1. |

### Public Timer and Tween Types

| Type | Public surface and behavior |
|------|-----------------------------|
| `Cooldown` | Mutable timer with `duration`, `isReady`, `remaining`, `progress`, `update`, `trigger`, `reset`, `tryTrigger`, and `setRemaining`. Remaining time is externally clamped to non-negative values. |
| `TickAccumulator` | Fixed-step accumulator with `fixedDeltaTime`, `init(fixedDeltaTime:)`, `withFrequency`, `tickCount`, interpolation `alpha`, consuming `add`, callback-driven `update`, `reset`, and `currentAccumulator`. |
| `Scheduler` | Actor-isolated scheduler exposing nested opaque `ScheduledEvent`, `scheduleOnce`, `scheduleRepeating`, `cancel`, `cancelAll`, `update`, `eventCount`, and `resetTime`. Callers advance logical time explicitly; callbacks are `@Sendable`. |
| `Tweenable` | Sendable interpolation protocol with `lerp(to:t:)`; built-in conformances cover `Double`, `Float`, `Vec2`, `Vec3`, and `Angle`. |
| `Tween` | Mutable typed tween with `start`, `end`, `duration`, `easing`, current `value`, `progress`, `completed`, `update`, `reset`, `seek`, `seekToProgress`, `reversed`, and presets `quadraticIn`, `quadraticOut`, `quadraticInOut`, `elasticOut`, `bounceOut`, and `backOut`. |
| `TweenManager` | Actor-isolated collection with `add`, convenience `tween`, `cancel`, `cancelAll`, `update`, `activeTweenCount`, `hasActiveTweens`, `tweenDouble`, `tweenVec2`, and `tweenAngle`. It returns UUID handles, invokes updates during manager updates, removes completed tweens, and then invokes completion callbacks. |
| `GameError` | Public descriptive error vocabulary: `invalidInput`, `invalidRange`, `invalidConfiguration`, `invalidState`, `pathfindingFailed`, `invalidDiceNotation`, `entityNotFound`, `componentNotFound`, `outOfBounds`, and `computationFailed`, with prefixed `description` text. Current utility APIs primarily use optional, boolean, or empty-result failure signals rather than throwing these cases. |

### Exported Symbol Index

The index below is parser-complete; caller-visible semantics and constraints are documented by each symbol's owning type contract above.

| Export | Contract location |
|--------|-------------------|
| `min` | Semantics and constraints are defined by the owning public type contract above. |
| `max` | Semantics and constraints are defined by the owning public type contract above. |
| `center` | Semantics and constraints are defined by the owning public type contract above. |
| `size` | Semantics and constraints are defined by the owning public type contract above. |
| `width` | Semantics and constraints are defined by the owning public type contract above. |
| `height` | Semantics and constraints are defined by the owning public type contract above. |
| `extents` | Semantics and constraints are defined by the owning public type contract above. |
| `contains` | Semantics and constraints are defined by the owning public type contract above. |
| `intersects` | Semantics and constraints are defined by the owning public type contract above. |
| `collisionResult` | Semantics and constraints are defined by the owning public type contract above. |
| `closestPoint` | Semantics and constraints are defined by the owning public type contract above. |
| `expanded` | Semantics and constraints are defined by the owning public type contract above. |
| `union` | Semantics and constraints are defined by the owning public type contract above. |
| `intersection` | Semantics and constraints are defined by the owning public type contract above. |
| `init` | Semantics and constraints are defined by the owning public type contract above. |
| `radius` | Semantics and constraints are defined by the owning public type contract above. |
| `diameter` | Semantics and constraints are defined by the owning public type contract above. |
| `area` | Semantics and constraints are defined by the owning public type contract above. |
| `collided` | Semantics and constraints are defined by the owning public type contract above. |
| `contactPoint` | Semantics and constraints are defined by the owning public type contract above. |
| `normal` | Semantics and constraints are defined by the owning public type contract above. |
| `depth` | Semantics and constraints are defined by the owning public type contract above. |
| `noCollision` | Semantics and constraints are defined by the owning public type contract above. |
| `collision` | Semantics and constraints are defined by the owning public type contract above. |
| `origin` | Semantics and constraints are defined by the owning public type contract above. |
| `direction` | Semantics and constraints are defined by the owning public type contract above. |
| `towards` | Semantics and constraints are defined by the owning public type contract above. |
| `point` | Semantics and constraints are defined by the owning public type contract above. |
| `cast` | Semantics and constraints are defined by the owning public type contract above. |
| `hit` | Semantics and constraints are defined by the owning public type contract above. |
| `distance` | Semantics and constraints are defined by the owning public type contract above. |
| `noHit` | Semantics and constraints are defined by the owning public type contract above. |
| `id` | Semantics and constraints are defined by the owning public type contract above. |
| `create` | Semantics and constraints are defined by the owning public type contract above. |
| `description` | Semantics and constraints are defined by the owning public type contract above. |
| `createEntity` | Semantics and constraints are defined by the owning public type contract above. |
| `destroyEntity` | Semantics and constraints are defined by the owning public type contract above. |
| `hasEntity` | Semantics and constraints are defined by the owning public type contract above. |
| `addComponent` | Semantics and constraints are defined by the owning public type contract above. |
| `removeComponent` | Semantics and constraints are defined by the owning public type contract above. |
| `getComponent` | Semantics and constraints are defined by the owning public type contract above. |
| `hasComponent` | Semantics and constraints are defined by the owning public type contract above. |
| `updateComponent` | Semantics and constraints are defined by the owning public type contract above. |
| `entitiesWith` | Semantics and constraints are defined by the owning public type contract above. |
| `entitiesWithAll` | Semantics and constraints are defined by the owning public type contract above. |
| `query` | Semantics and constraints are defined by the owning public type contract above. |
| `entityCount` | Semantics and constraints are defined by the owning public type contract above. |
| `clear` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidInput` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidRange` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidConfiguration` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidState` | Semantics and constraints are defined by the owning public type contract above. |
| `pathfindingFailed` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidDiceNotation` | Semantics and constraints are defined by the owning public type contract above. |
| `entityNotFound` | Semantics and constraints are defined by the owning public type contract above. |
| `componentNotFound` | Semantics and constraints are defined by the owning public type contract above. |
| `outOfBounds` | Semantics and constraints are defined by the owning public type contract above. |
| `computationFailed` | Semantics and constraints are defined by the owning public type contract above. |
| `radians` | Semantics and constraints are defined by the owning public type contract above. |
| `degrees` | Semantics and constraints are defined by the owning public type contract above. |
| `zero` | Semantics and constraints are defined by the owning public type contract above. |
| `quarter` | Semantics and constraints are defined by the owning public type contract above. |
| `half` | Semantics and constraints are defined by the owning public type contract above. |
| `threeQuarters` | Semantics and constraints are defined by the owning public type contract above. |
| `full` | Semantics and constraints are defined by the owning public type contract above. |
| `normalized` | Semantics and constraints are defined by the owning public type contract above. |
| `normalizedSigned` | Semantics and constraints are defined by the owning public type contract above. |
| `difference` | Semantics and constraints are defined by the owning public type contract above. |
| `lerp` | Semantics and constraints are defined by the owning public type contract above. |
| `+` | Semantics and constraints are defined by the owning public type contract above. |
| `-` | Semantics and constraints are defined by the owning public type contract above. |
| `*` | Semantics and constraints are defined by the owning public type contract above. |
| `/` | Semantics and constraints are defined by the owning public type contract above. |
| `+=` | Semantics and constraints are defined by the owning public type contract above. |
| `-=` | Semantics and constraints are defined by the owning public type contract above. |
| `*=` | Semantics and constraints are defined by the owning public type contract above. |
| `/=` | Semantics and constraints are defined by the owning public type contract above. |
| `linear` | Semantics and constraints are defined by the owning public type contract above. |
| `quadraticIn` | Semantics and constraints are defined by the owning public type contract above. |
| `quadraticOut` | Semantics and constraints are defined by the owning public type contract above. |
| `quadraticInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `cubicIn` | Semantics and constraints are defined by the owning public type contract above. |
| `cubicOut` | Semantics and constraints are defined by the owning public type contract above. |
| `cubicInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `quarticIn` | Semantics and constraints are defined by the owning public type contract above. |
| `quarticOut` | Semantics and constraints are defined by the owning public type contract above. |
| `quarticInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `quinticIn` | Semantics and constraints are defined by the owning public type contract above. |
| `quinticOut` | Semantics and constraints are defined by the owning public type contract above. |
| `quinticInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `sineIn` | Semantics and constraints are defined by the owning public type contract above. |
| `sineOut` | Semantics and constraints are defined by the owning public type contract above. |
| `sineInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `exponentialIn` | Semantics and constraints are defined by the owning public type contract above. |
| `exponentialOut` | Semantics and constraints are defined by the owning public type contract above. |
| `exponentialInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `circularIn` | Semantics and constraints are defined by the owning public type contract above. |
| `circularOut` | Semantics and constraints are defined by the owning public type contract above. |
| `circularInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `elasticIn` | Semantics and constraints are defined by the owning public type contract above. |
| `elasticOut` | Semantics and constraints are defined by the owning public type contract above. |
| `elasticInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `backIn` | Semantics and constraints are defined by the owning public type contract above. |
| `backOut` | Semantics and constraints are defined by the owning public type contract above. |
| `backInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `bounceIn` | Semantics and constraints are defined by the owning public type contract above. |
| `bounceOut` | Semantics and constraints are defined by the owning public type contract above. |
| `bounceInOut` | Semantics and constraints are defined by the owning public type contract above. |
| `inverseLerp` | Semantics and constraints are defined by the owning public type contract above. |
| `remap` | Semantics and constraints are defined by the owning public type contract above. |
| `smoothstep` | Semantics and constraints are defined by the owning public type contract above. |
| `smootherstep` | Semantics and constraints are defined by the owning public type contract above. |
| `clamp` | Semantics and constraints are defined by the owning public type contract above. |
| `clamp01` | Semantics and constraints are defined by the owning public type contract above. |
| `moveTowards` | Semantics and constraints are defined by the owning public type contract above. |
| `exponentialDecay` | Semantics and constraints are defined by the owning public type contract above. |
| `spring` | Semantics and constraints are defined by the owning public type contract above. |
| `pingPong` | Semantics and constraints are defined by the owning public type contract above. |
| `x` | Semantics and constraints are defined by the owning public type contract above. |
| `y` | Semantics and constraints are defined by the owning public type contract above. |
| `right` | Semantics and constraints are defined by the owning public type contract above. |
| `up` | Semantics and constraints are defined by the owning public type contract above. |
| `left` | Semantics and constraints are defined by the owning public type contract above. |
| `down` | Semantics and constraints are defined by the owning public type contract above. |
| `one` | Semantics and constraints are defined by the owning public type contract above. |
| `magnitude` | Semantics and constraints are defined by the owning public type contract above. |
| `magnitudeSquared` | Semantics and constraints are defined by the owning public type contract above. |
| `dot` | Semantics and constraints are defined by the owning public type contract above. |
| `cross` | Semantics and constraints are defined by the owning public type contract above. |
| `distanceSquared` | Semantics and constraints are defined by the owning public type contract above. |
| `angle` | Semantics and constraints are defined by the owning public type contract above. |
| `perpendicular` | Semantics and constraints are defined by the owning public type contract above. |
| `rotated` | Semantics and constraints are defined by the owning public type contract above. |
| `absolute` | Semantics and constraints are defined by the owning public type contract above. |
| `clamped` | Semantics and constraints are defined by the owning public type contract above. |
| `fromAngle` | Semantics and constraints are defined by the owning public type contract above. |
| `reflected` | Semantics and constraints are defined by the owning public type contract above. |
| `projected` | Semantics and constraints are defined by the owning public type contract above. |
| `z` | Semantics and constraints are defined by the owning public type contract above. |
| `forward` | Semantics and constraints are defined by the owning public type contract above. |
| `back` | Semantics and constraints are defined by the owning public type contract above. |
| `xy` | Semantics and constraints are defined by the owning public type contract above. |
| `xz` | Semantics and constraints are defined by the owning public type contract above. |
| `findPath` | Semantics and constraints are defined by the owning public type contract above. |
| `findPathInGrid` | Semantics and constraints are defined by the owning public type contract above. |
| `Node` | Semantics and constraints are defined by the owning public type contract above. |
| `neighbors` | Semantics and constraints are defined by the owning public type contract above. |
| `cost` | Semantics and constraints are defined by the owning public type contract above. |
| `manhattan` | Semantics and constraints are defined by the owning public type contract above. |
| `euclidean` | Semantics and constraints are defined by the owning public type contract above. |
| `chebyshev` | Semantics and constraints are defined by the owning public type contract above. |
| `octile` | Semantics and constraints are defined by the owning public type contract above. |
| `isWalkable` | Semantics and constraints are defined by the owning public type contract above. |
| `isValid` | Semantics and constraints are defined by the owning public type contract above. |
| `setWalkable` | Semantics and constraints are defined by the owning public type contract above. |
| `nodes` | Semantics and constraints are defined by the owning public type contract above. |
| `found` | Semantics and constraints are defined by the owning public type contract above. |
| `length` | Semantics and constraints are defined by the owning public type contract above. |
| `start` | Semantics and constraints are defined by the owning public type contract above. |
| `goal` | Semantics and constraints are defined by the owning public type contract above. |
| `notFound` | Semantics and constraints are defined by the owning public type contract above. |
| `==` | Semantics and constraints are defined by the owning public type contract above. |
| `startIndex` | Semantics and constraints are defined by the owning public type contract above. |
| `endIndex` | Semantics and constraints are defined by the owning public type contract above. |
| `index` | Semantics and constraints are defined by the owning public type contract above. |
| `subscript` | Semantics and constraints are defined by the owning public type contract above. |
| `count` | Semantics and constraints are defined by the owning public type contract above. |
| `sides` | Semantics and constraints are defined by the owning public type contract above. |
| `modifier` | Semantics and constraints are defined by the owning public type contract above. |
| `roll` | Semantics and constraints are defined by the owning public type contract above. |
| `minimum` | Semantics and constraints are defined by the owning public type contract above. |
| `maximum` | Semantics and constraints are defined by the owning public type contract above. |
| `average` | Semantics and constraints are defined by the owning public type contract above. |
| `d4` | Semantics and constraints are defined by the owning public type contract above. |
| `d6` | Semantics and constraints are defined by the owning public type contract above. |
| `d8` | Semantics and constraints are defined by the owning public type contract above. |
| `d10` | Semantics and constraints are defined by the owning public type contract above. |
| `d12` | Semantics and constraints are defined by the owning public type contract above. |
| `d20` | Semantics and constraints are defined by the owning public type contract above. |
| `d100` | Semantics and constraints are defined by the owning public type contract above. |
| `twod6` | Semantics and constraints are defined by the owning public type contract above. |
| `threed6` | Semantics and constraints are defined by the owning public type contract above. |
| `nextUInt64` | Semantics and constraints are defined by the owning public type contract above. |
| `nextDouble` | Semantics and constraints are defined by the owning public type contract above. |
| `nextFloat` | Semantics and constraints are defined by the owning public type contract above. |
| `nextInt` | Semantics and constraints are defined by the owning public type contract above. |
| `nextBool` | Semantics and constraints are defined by the owning public type contract above. |
| `nextElement` | Semantics and constraints are defined by the owning public type contract above. |
| `shuffle` | Semantics and constraints are defined by the owning public type contract above. |
| `shuffled` | Semantics and constraints are defined by the owning public type contract above. |
| `nextVec2` | Semantics and constraints are defined by the owning public type contract above. |
| `nextVec3` | Semantics and constraints are defined by the owning public type contract above. |
| `nextAngle` | Semantics and constraints are defined by the owning public type contract above. |
| `nextDirection2D` | Semantics and constraints are defined by the owning public type contract above. |
| `nextGridCoord` | Semantics and constraints are defined by the owning public type contract above. |
| `Entry` | Semantics and constraints are defined by the owning public type contract above. |
| `item` | Semantics and constraints are defined by the owning public type contract above. |
| `weight` | Semantics and constraints are defined by the owning public type contract above. |
| `quantity` | Semantics and constraints are defined by the owning public type contract above. |
| `LootResult` | Semantics and constraints are defined by the owning public type contract above. |
| `rollCombined` | Semantics and constraints are defined by the owning public type contract above. |
| `guaranteed` | Semantics and constraints are defined by the owning public type contract above. |
| `rare` | Semantics and constraints are defined by the owning public type contract above. |
| `WeightedItem` | Semantics and constraints are defined by the owning public type contract above. |
| `element` | Semantics and constraints are defined by the owning public type contract above. |
| `select` | Semantics and constraints are defined by the owning public type contract above. |
| `selectUnique` | Semantics and constraints are defined by the owning public type contract above. |
| `isEmpty` | Semantics and constraints are defined by the owning public type contract above. |
| `orthogonalNeighbors` | Semantics and constraints are defined by the owning public type contract above. |
| `allNeighbors` | Semantics and constraints are defined by the owning public type contract above. |
| `allCoordinates` | Semantics and constraints are defined by the owning public type contract above. |
| `map` | Semantics and constraints are defined by the owning public type contract above. |
| `coordinates` | Semantics and constraints are defined by the owning public type contract above. |
| `fill` | Semantics and constraints are defined by the owning public type contract above. |
| `subgrid` | Semantics and constraints are defined by the owning public type contract above. |
| `hash` | Semantics and constraints are defined by the owning public type contract above. |
| `diagonalNeighbors` | Semantics and constraints are defined by the owning public type contract above. |
| `manhattanDistance` | Semantics and constraints are defined by the owning public type contract above. |
| `chebyshevDistance` | Semantics and constraints are defined by the owning public type contract above. |
| `euclideanDistance` | Semantics and constraints are defined by the owning public type contract above. |
| `toWorldPosition` | Semantics and constraints are defined by the owning public type contract above. |
| `fromWorldPosition` | Semantics and constraints are defined by the owning public type contract above. |
| `Item` | Semantics and constraints are defined by the owning public type contract above. |
| `position` | Semantics and constraints are defined by the owning public type contract above. |
| `insert` | Semantics and constraints are defined by the owning public type contract above. |
| `nearest` | Semantics and constraints are defined by the owning public type contract above. |
| `bounds` | Semantics and constraints are defined by the owning public type contract above. |
| `remove` | Semantics and constraints are defined by the owning public type contract above. |
| `update` | Semantics and constraints are defined by the owning public type contract above. |
| `onEnter` | Semantics and constraints are defined by the owning public type contract above. |
| `onUpdate` | Semantics and constraints are defined by the owning public type contract above. |
| `onExit` | Semantics and constraints are defined by the owning public type contract above. |
| `TransitionCallback` | Semantics and constraints are defined by the owning public type contract above. |
| `current` | Semantics and constraints are defined by the owning public type contract above. |
| `register` | Semantics and constraints are defined by the owning public type contract above. |
| `transition` | Semantics and constraints are defined by the owning public type contract above. |
| `onTransition` | Semantics and constraints are defined by the owning public type contract above. |
| `isInState` | Semantics and constraints are defined by the owning public type contract above. |
| `isInAnyState` | Semantics and constraints are defined by the owning public type contract above. |
| `duration` | Semantics and constraints are defined by the owning public type contract above. |
| `isReady` | Semantics and constraints are defined by the owning public type contract above. |
| `remaining` | Semantics and constraints are defined by the owning public type contract above. |
| `progress` | Semantics and constraints are defined by the owning public type contract above. |
| `trigger` | Semantics and constraints are defined by the owning public type contract above. |
| `reset` | Semantics and constraints are defined by the owning public type contract above. |
| `tryTrigger` | Semantics and constraints are defined by the owning public type contract above. |
| `setRemaining` | Semantics and constraints are defined by the owning public type contract above. |
| `ScheduledEvent` | Semantics and constraints are defined by the owning public type contract above. |
| `scheduleOnce` | Semantics and constraints are defined by the owning public type contract above. |
| `scheduleRepeating` | Semantics and constraints are defined by the owning public type contract above. |
| `cancel` | Semantics and constraints are defined by the owning public type contract above. |
| `cancelAll` | Semantics and constraints are defined by the owning public type contract above. |
| `eventCount` | Semantics and constraints are defined by the owning public type contract above. |
| `resetTime` | Semantics and constraints are defined by the owning public type contract above. |
| `fixedDeltaTime` | Semantics and constraints are defined by the owning public type contract above. |
| `withFrequency` | Semantics and constraints are defined by the owning public type contract above. |
| `tickCount` | Semantics and constraints are defined by the owning public type contract above. |
| `alpha` | Semantics and constraints are defined by the owning public type contract above. |
| `add` | Semantics and constraints are defined by the owning public type contract above. |
| `currentAccumulator` | Semantics and constraints are defined by the owning public type contract above. |
| `end` | Semantics and constraints are defined by the owning public type contract above. |
| `easing` | Semantics and constraints are defined by the owning public type contract above. |
| `value` | Semantics and constraints are defined by the owning public type contract above. |
| `completed` | Semantics and constraints are defined by the owning public type contract above. |
| `seek` | Semantics and constraints are defined by the owning public type contract above. |
| `seekToProgress` | Semantics and constraints are defined by the owning public type contract above. |
| `reversed` | Semantics and constraints are defined by the owning public type contract above. |
| `tween` | Semantics and constraints are defined by the owning public type contract above. |
| `activeTweenCount` | Semantics and constraints are defined by the owning public type contract above. |
| `hasActiveTweens` | Semantics and constraints are defined by the owning public type contract above. |
| `tweenDouble` | Semantics and constraints are defined by the owning public type contract above. |
| `tweenVec2` | Semantics and constraints are defined by the owning public type contract above. |
| `tweenAngle` | Semantics and constraints are defined by the owning public type contract above. |

## Invariants

1. All public values and actor messages that cross concurrency boundaries are `Sendable`; mutable shared stores (`World`, `StateMachine`, `Quadtree`, `Scheduler`, and `TweenManager`) are actor-isolated.
2. `Vec2.normalized()` and `Vec3.normalized()` return `.zero` for zero magnitude, and projection onto a zero vector returns `.zero`.
3. `Ray` normalizes its supplied direction at initialization, so returned cast distances are measured along a unit direction unless the supplied direction is zero.
4. Collision containment and intersection checks include exact boundary contact; detailed result optionals are populated only for a reported collision or hit.
5. Grid coordinates are valid only for `0 <= x < width` and `0 <= y < height`; invalid grid subscripts do not trap.
6. Seeded `GameRandom` sequences and consumers such as `Dice` and `WeightedRandom` are deterministic for the same seed and call order.
7. A* path cost is the sum of graph edge costs, returned nodes include start and goal, and failure is represented by an empty infinite-cost `Path.notFound`.
8. Actor-managed timers, schedulers, state machines, and tweens advance only when their public update methods are called; the package starts no background loop.
9. `Cooldown.remaining`, tween seek time/progress, and loot drop chance are clamped by their implementations; easing curves themselves generally do not clamp their input.
10. Collection query methods return value snapshots; callers cannot mutate actor or index internals through returned arrays or sets.

## Behavioral Examples

### Scenario: deterministic weighted roll

- **Given** two `GameRandom` values created with the same seed and equivalent `WeightedRandom` inputs
- **When** callers perform selections in the same order
- **Then** both callers receive the same sequence, while empty or zero-total selectors return `nil`

### Scenario: grid path around obstacles

- **Given** a `NavigationGrid` with blocked cells and diagonal movement disabled
- **When** `AStar.findPathInGrid` is asked for a reachable start and goal
- **Then** every returned node is walkable, consecutive nodes are orthogonal neighbors, and the path includes both endpoints

### Scenario: actor-managed tween lifecycle

- **Given** a tween registered with `TweenManager`
- **When** the caller advances the manager until the tween completes
- **Then** update callbacks receive interpolated values, the tween is removed, and its completion callback runs once

### Scenario: collision miss

- **Given** separated shapes or a ray whose nearest intersection exceeds `maxDistance`
- **When** the relevant collision or raycast query runs
- **Then** it returns `CollisionResult.noCollision`, `RaycastHit.noHit`, or `nil` distance without throwing

## Error Cases

| Condition | Behavior |
|-----------|----------|
| Invalid dice notation | `Dice.init(notation:)` returns `nil`; it does not throw `GameError.invalidDiceNotation`. |
| Empty random input or non-positive total weight | Element/weighted selection returns `nil`; multi-selection returns an empty array. |
| Non-positive `nextInt(upperBound:)` | Returns `0`. Callers remain responsible for supplying meaningful ranges to range-based APIs. |
| Out-of-bounds grid access | Read returns `nil`; write is ignored; `NavigationGrid.isWalkable` returns `false`. |
| Quadtree point outside root bounds | `insert` returns `false`. |
| No route, collision, intersection, or ray hit | Returns `Path.notFound`, a no-result value, or `nil` as appropriate. |
| Missing ECS entity/component | Query methods return `false`/`nil`/empty results and writes to unknown entities do nothing. |
| Zero vector normalization/projection | Returns zero rather than producing a divide-by-zero result. |
| Equal inverse-lerp endpoints or non-positive repeat length | Returns `0`. |

## Dependencies

### Consumes

| Module | What is used |
|--------|-------------|
| Swift standard library | Value semantics, collections, numeric operations, protocols, actors, and concurrency annotations. |
| Foundation | `UUID`, `Date`, regular expressions, and elementary math functions. |
| `swift-docc-plugin` | Build-time documentation generation only; it is not linked into the `Game` library product. |

### Consumed By

| Module | What is used |
|--------|-------------|
| Package clients | The `Game` library product and its public math, simulation, selection, and coordination APIs. |
| `GameTests` | Deterministic contract coverage across all nine functional areas. |

## Change Log

| Date | Author | Change |
|------|--------|--------|
| 2026-07-13 | CorvidLabs | Documented the existing 35-file, 3,352-line public contract during SpecSync 5.0.1 / Trust 1.0.0 adoption; no product behavior changed. |
| 2026-07-14 | CHG-0002-document-the-complete-existing-swift-game-api-and-behavior-for-specsync-5-0-1: Document the complete existing Swift Game API and behavior for SpecSync 5.0.1 |
| 2026-07-14 | CHG-0002-document-the-complete-existing-swift-game-api-and-behavior-for-specsync-5-0-1: Document the complete existing Swift Game API and behavior for SpecSync 5.0.1 |
