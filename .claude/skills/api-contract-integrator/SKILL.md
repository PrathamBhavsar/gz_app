---
name: api-contract-integrator
description: Use when adding or changing API calls, repositories, request or response models, endpoint mappings, auth headers, caching, or error handling in Flutter apps.
---

# API Contract Integrator

## Purpose

Integrate backend contracts without leaking transport details into UI or state layers.

## Required Context

Use `brain-router`, then load the repo's API reference, API contract rules, data layer rules, error handling rules, and caching rules if they exist.

## Integration Flow

1. Locate the endpoint in the API reference before writing code.
2. Confirm method, path, auth, query/body fields, response shape, and failure cases.
3. Add or update request/response models in the repo-approved style.
4. Add repository methods that wrap the HTTP client.
5. Map transport errors to the repo's typed failure or exception model.
6. Expose data through providers/notifiers only; UI must not call repositories directly.
7. Apply cache/TTL/image-cache rules for GET and media endpoints.
8. Add focused tests or fixtures where the repo has test patterns.

## Contract Rules

- Never hardcode base URLs, API keys, or secrets.
- Never let `DioException`, raw `http.Response`, or transport objects leak into UI.
- Never parse JSON in widgets.
- Never silently swallow backend failures.
- Do not guess missing endpoint fields; inspect the API docs or ask.

## Verification

- Run the repo's codegen command after generated model/provider changes.
- Run analyzer and focused tests.
- If no tests exist, document the manual contract checks performed.
