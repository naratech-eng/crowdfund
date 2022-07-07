const routes = require("next-routes")();

routes
  .add("/campaigns/new_campaign", "/campaigns/new_campaign")
  .add("/campaigns/:address", "/campaigns/display")
  .add("/campaigns/:address/requests", "/campaigns/requests/index")
  .add("/campaigns/:address/requests/new", "/campaigns/requests/new");

module.exports = routes;