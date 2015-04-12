"use strict";

Formidably.Views.Dashboard = Backbone.View.extend({
  initialize: function(options) {
    var t = this;
    Formidably.Jobs.syncWithCaptricity(function() {
      return t.render();
    });
  },

  template: JST['backbone/templates/dashboard'],

  render: function() {
    this.$el.html(this.template({
      user: Formidably.currentUser,
      jobs: Formidably.Jobs.models
    }));
    return this;
  },
  
});