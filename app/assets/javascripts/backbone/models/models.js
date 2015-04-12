"use strict";

Formidably.Models.Batch = Backbone.Model.extend({
  initialize: function() {

  },
  urlRoot: '/api/v1/batches'
});

Formidably.Collections.Batches = Backbone.Collection.extend({
  model: Formidably.Models.Batch,
  url: '/api/v1/batches'
});

Formidably.Models.Job = Backbone.Model.extend({
  initialize: function(options) {
    if (options.captricityJob) { // Initializing from Captricity Job
      var cJob = options.captricityJob; // A Backbone model
      this.set('cid', cJob.id);
      this.set('name', cJob.get('name'));
      this.set('document_cid', cJob.get('document_id'));
      this.set('created', cJob.get('created'));
      this.set('status', cJob.get('status'));
    }
    return this;
  },
  urlRoot: '/api/v1/jobs'
});

Formidably.Collections.Jobs = Backbone.Collection.extend({
  model: Formidably.Models.Job,
  url: '/api/v1/jobs',
  comparator: function(one, two) {
    if (one.get('created') > two.get('created')) { return -1; }
    if (one.get('created') < two.get('created')) { return 1; }
    return 0;
  },
  syncWithCaptricity: function(callback) {
    var t = this;
    captricity.Jobs.fetch({success: function(captricityJobs) {
      console.log('cap jobs', captricityJobs);
      console.log('my jobs', t.models);
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
      // t.models = captricityJobs.models;
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