# Steps to reproduce

- `npm run prepare:containers`
- `npm run cypress:open`
- Select "E2E testing"
- Select Chrome
- Run manualActivation.cy.js

# Expected

There are two test suites. They are the exact same, with the exception of the domain and that one uses cy.origin to accommodate the random renerated domain
Both tests should work the same and succeed

# Actual

The firs test, that uses cy.origin fails under _chrome_, the second succceeds

# Cleanup

For ease of use I created

- `npm run destroy:containers`

This removes the containers and docker network that this test created
