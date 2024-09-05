# ruby-assignment
**Struct Inheritance:** It's uncommon to inherit from Struct. Use a plain class and initialize values via an initialize method.

**Guard Clauses:** Use guard clauses to avoid deeply nested if conditions.

**Memoization**: Memoize repeated calls like account.lead_campaigns.
Cached lead_campaigns with @lead_campaigns ||=.

**Extract** Complex Logic: The build_onboarding_list method has a lot going on; it would be clearer if parts of the logic were extracted into separate methods.

**Use &. for Nil Checking:** In Rails, use &. for safe navigation to prevent nil errors.

**Naming and Consistency**: perform_lead_finder_search and build_onboarding_list methods can be renamed to be more descriptive.
