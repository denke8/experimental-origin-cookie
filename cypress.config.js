const { defineConfig } = require("cypress");
const setupPlugins = require("./cypress/plugins");

module.exports = defineConfig({
  chromeWebSecurity: false,
  viewportHeight: 937,
  viewportWidth: 1920,
  defaultCommandTimeout: 40000,
  retries: {
    runMode: 1,
    openMode: 0,
  },
  e2e: {
    setupNodeEvents: setupPlugins,
    experimentalSessionAndOrigin: true,
    // The installed WP baseUrl will change from test to test, but we need
    // this to match CYPRESS_WP_BASE_DOMAIN for cypress to even start
    baseUrl: "http://wp-plugin-e2e.loc/",
    hosts: {
      "*.loc": "127.0.0.1",
    },
  },
});
