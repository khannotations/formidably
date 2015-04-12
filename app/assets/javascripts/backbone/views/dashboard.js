"use strict";

Formidably.Views.Dashboard = Backbone.View.extend({
  initialize: function(options) {
    var t = this;
    Formidably.Jobs.syncWithCaptricity(function() {
      t.renderJobs();
    });
    return this.render();
  },

  template: JST['backbone/templates/dashboard'],
  jobsTemplate: JST['backbone/templates/dashboard_jobs'],

  render: function() {
    this.$el.html(this.template({ user: Formidably.currentUser }));
    return this;
  },

  renderJobs: function() {
    $("#jobs").html(this.jobsTemplate({ jobs: Formidably.Jobs.models.sort() }))
    return this;
  }
});