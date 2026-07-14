---
change: CHG-0002-document-the-complete-existing-swift-game-api-and-behavior-for-specsync-5-0-1
artifact: testing
---

# Testing

- Run `specsync check --strict --require-coverage 100 --force` and require 35/35 files, 3,352/3,352 lines, A/100 quality, and no undocumented exports.
- Run `fledge lanes run verify` and require the native build plus all 157 tests in nine suites to pass.
- Run `specsync agents status` and `fledge trust doctor`.
- Run committed-range Trust and exact-head hosted Trust/CodeQL before merge.
- Confirm `git diff origin/main...HEAD -- Sources Tests Package.swift` is empty.
- Treat the companion's named source-reviewed surfaces as review evidence only; do not convert them into fabricated executed-test claims.

## Requirement Evidence Mapping

| Requirement | Verification evidence |
|-------------|-----------------------|
| REQ-game-001 | Math tests plus parser-complete Vec2, Vec3, and Angle export review. |
| REQ-game-002 | Math easing/interpolation tests plus source review of every easing family. |
| REQ-game-003 | All 25 collision tests. |
| REQ-game-004 | Native actor compilation and source review of typed World operations. |
| REQ-game-005 | All 18 spatial tests plus explicit SpatialHash source review. |
| REQ-game-006 | All 16 pathfinding tests. |
| REQ-game-007 | All 26 random tests. |
| REQ-game-008 | LootTable source review, explicitly not a direct-test claim. |
| REQ-game-009 | All nine state-machine tests. |
| REQ-game-010 | Timer tests plus explicit Scheduler/TickAccumulator source review. |
| REQ-game-011 | All 22 tween value tests plus explicit TweenManager source review. |
| REQ-game-012 | Native Swift build, complete 157-test lane, actor/sendability compilation, and unchanged product files. |
