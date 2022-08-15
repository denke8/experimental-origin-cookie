import { v4 as uuid } from "uuid";

const generateUniqueDomain = () => {
  const [rnd] = uuid().split("-");

  return `e2etest-${rnd}.loc`.toLowerCase();
};

Cypress.Commands.add("resetTestingEnv", ({ randomBaseUrl } = {}) => {
  const domain = randomBaseUrl
    ? generateUniqueDomain()
    : Cypress.env("CYPRESS_WP_BASE_DOMAIN");

  const baseUrl = `http://${domain}`;

  return cy
    .exec(`scripts/reset_testing_env.sh --base ${domain}`)
    .then(() => baseUrl);
});
