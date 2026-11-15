## Summary
Describe the changes made and reference any related issue (`Closes #<issue>`).

## Type of Change
- [ ] Bug fix
- [ ] New guard method / validator
- [ ] Context or `IGuardFailureHandler` enhancement
- [ ] Documentation / ApexDoc update

## Checklist
- [ ] Positive assertion naming (`.NET CommunityToolkit.Diagnostics.Guard` style)
- [ ] Pass-through return value implemented where applicable
- [ ] Custom `String message` and `Exception customException` overloads included
- [ ] Zero external dependencies and zero SOQL/DML introduced
- [ ] Full ApexDoc (`@description`, `@param`, `@return`, `@throws`) added to all public classes/methods/overloads
- [ ] Companion `.cls-meta.xml` files included (`apiVersion` 62.0)
- [ ] Unit tests added/updated in `force-app/main/default/classes/tests/` covering valid inputs, boundaries, nulls, and failure metadata
- [ ] `README.md` / `docs/` updated if public API changed
