# RULE: LAYOUT & ROUTING
> **Enforcement Level**: CRITICAL

1. **go_router:** All navigation uses `context.go()` or `context.push()`. No raw `Navigator`.
2. **Route Constants:** Define all routes in `AppRoutes`. No hardcoded string paths in UI.
3. **Breakpoints:** Use a strict 2-screen model (Mobile < 600px, Tablet >= 600px). No raw `MediaQuery.of(context).size` for conditional logic—use a dedicated layout builder wrapper.
