---
spec: game.spec.md
---

## Completed Tasks

- [x] Inventory all 35 source files, 3,352 source lines, nine test files, and 157 deterministic tests.
- [x] Document every implemented public type, protocol, member family, invariant, boundary, and failure signal without changing product semantics.
- [x] Map the canonical companion to every source file and configure contract enforcement at 100%.
- [x] Preserve the existing package, source, test, Ubuntu, macOS, DocC Pages, and CodeQL behavior.
- [x] Install Claude, Cursor, Codex, and Gemini SpecSync integrations.
- [x] Configure the immutable Trust 1.0.0 action to run the native Fledge verification lane.

## Verification Boundaries

- Deterministic unit tests cover the functional contracts listed in `testing.md`.
- Actor scheduling is driven synchronously by test-controlled updates; long-running timing and performance limits are not claimed.
- Hosted Ubuntu and macOS jobs remain the platform evidence; this governance change does not add a Windows claim.

## Review Sign-offs

- **Contract review**: source-derived companion complete; parser/coverage verification required before acceptance.
- **Native QA**: build and 157-test Fledge lane required before acceptance.
- **Hosted QA**: exact-head Trust and CodeQL required before merge.
- **Design**: not applicable; no product or visual behavior changes.
