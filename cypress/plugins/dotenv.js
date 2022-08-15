/* eslint-disable import/no-extraneous-dependencies */
require("dotenv").config();

module.exports = (on, config) => {
  // Use dotenv to set envs in config (accessed by Cypress.env())
  const envs = Object.keys(process.env)
    .filter((key) => key.startsWith("CYPRESS_"))
    .reduce(
      (acc, key) => ({
        ...acc,
        [key]: process.env[key],
      }),
      {}
    );

  return { ...config, env: { ...config.env, ...envs } };
};
