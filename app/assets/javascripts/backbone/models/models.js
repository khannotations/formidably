"use strict";

Formidably.Models.Batch = Backbone.Model.extend({
  initialize: function() {

  },
});

Formidably.Collections.Batches = Backbone.Collection.extend({
  model: Formidably.Models.Batch,
  url: '/api/v1/batch'
});

Formidably.Models.Job = Backbone.Model.extend({
  initialize: function() {

  },
});

Formidably.Collections.Jobs = Backbone.Collection.extend({
  model: Formidably.Models.Job,
  url: '/api/v1/job',
  syncWithCaptricity: function(callback) {
    var t = this;
    captricity.Jobs.fetch({success: function(captricityJobs) {
      console.log('cap jobs', captricityJobs);
      t.each(function(job) {
        // Find the corresponding job
        var matchingJob = _.find(captricityJobs.models, function(capJob) {
          return capJob.id === job.get('cid');
        });
        if (!matchingJob) {
          console.log("ghost job..?");
        } else {
          job.set(matchingJob.attributes);
          console.log("match", job, matchingJob);
        }
      });
      if (typeof(callback) === 'function') {
        callback();
      }
    }});
  }
});

// Documents (largely a placeholder; don't interact with backend)
Formidably.Models.Document = Backbone.Model.extend({});
Formidably.Collections.Documents = Backbone.Collection.extend({
  model: Formidably.Models.Document
});