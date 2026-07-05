# RULE: PERFORMANCE

1. **const Everywhere:** Unnecessary rebuilds are a violation. Use `const` on all static widgets.
2. **ref.select:** Use `ref.watch(provider.select(...))` for partial state to prevent over-rendering.
3. **List Rendering:** Use `ListView.builder` for dynamic lists. Eager `ListView(children: [...])` is forbidden for data.
