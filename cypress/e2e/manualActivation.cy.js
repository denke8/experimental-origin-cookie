describe("Manual plugin activation", () => {
  describe("w/ random domain", () => {
    let wpBaseUrl;
    beforeEach(() => {
      // Using random base url so site is not autodiscovered
      cy.resetTestingEnv({ randomBaseUrl: true }).then((url) => {
        wpBaseUrl = url;
      });
    });

    it("should display signup CTA when autoconfig fails", () => {
      cy.origin(wpBaseUrl, {}, () => {
        cy.visit("/wp-admin");

        // eslint-disable-next-line cypress/no-unnecessary-waiting
        cy.wait(500); // The login page clears/resets the input from js whan loaded, so need to wait

        cy.contains("Username").type(Cypress.env("CYPRESS_WP_ADMIN_USER"));
        cy.contains("Password").type(Cypress.env("CYPRESS_WP_ADMIN_PASS"));
        cy.contains("Log In").click();

        cy.contains("Dashboard").should("exist");

        cy.visit("/wp-admin/plugins.php");

        cy.contains("Plugins").should("exist");
      });
    });
  });

  describe("w/ standard domain", () => {
    beforeEach(() => {
      // Using random base url so site is not autodiscovered
      cy.resetTestingEnv();
    });

    it("should display MS admin link when autoconfig succeeds", () => {
      cy.visit("/wp-admin");

      // eslint-disable-next-line cypress/no-unnecessary-waiting
      cy.wait(500); // The login page clears/resets the input from js whan loaded, so need to wait

      cy.contains("Username").type(Cypress.env("CYPRESS_WP_ADMIN_USER"));
      cy.contains("Password").type(Cypress.env("CYPRESS_WP_ADMIN_PASS"));
      cy.contains("Log In").click();

      cy.contains("Dashboard").should("exist");

      cy.visit("/wp-admin/plugins.php");

      cy.contains("Plugins").should("exist");
    });
  });
});
