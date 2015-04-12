"use strict";

Formidably.Views.Upload = Backbone.View.extend({
  initialize: function() {
    console.log(Formidably.Documents);
    return this.render();
  },
  template: JST['backbone/templates/upload'],
  events: {
    "click .js-template": "selectTemplate",
    "change #files": "filesChange",
    "click #submit": "submitFiles",
    "click #submit-job": "submitJob"
  },
  render: function() {
    this.$el.html(this.template({templates: Formidably.Documents.models}));
    return this;
  },

  // Events
  selectTemplate: function(e) {
    var t = e.currentTarget;
    $(".js-template.selected").removeClass("selected");
    $(t).addClass("selected");
    this.selectedTemplateId = $(t).data("cid"); // Captricity ID
    console.log(this.selectedTemplateId);
  },
  filesChange: function() {
    this.selectedFiles = $("#files")[0].files;
    console.log("files change", this.selectedFiles);
    $('#upload-progress').css('width', 0).text("0%");
    $("#price").text("");
    $("#readiness").text("");
    $("#submit-batch").hide();
  },
  // Events
  submitFiles: function() {
    if (!this.selectedTemplateId) {
      alert("Please select a template before uploading files.");
      return false;
    }
    if (!this.selectedFiles || !this.selectedFiles.length) {
      alert("Please choose at least one file to upload.");
      return false;
    }
    if (!this.filesAreValid()) {
      alert(this.fileError);
      return false;
    }
    var t = this;
    captricity.Jobs.create({
      name: this.generateBatchName(),
      document_id: this.selectedTemplateId,
    }, {
      success: function(job) {
        t.captricityJob = job;
        t.job = new Formidably.Models.Job({captricityJob: t.captricityJob});
        t.job.save();
        Formidably.Jobs.add(t.job);
        console.log(t.captricityJob, t.job);
        // Successfully created a job
        t.uploadFilesToJob(); // Start file upload
      },
      error: function() {
        console.log("error");
      }
    })
  },

  submitJob: function() {
    var t = this;
    captricity.apiPost(captricity.url.submitJob(this.captricityJob.id), {
      success: function() {
        t.job.set('started', "");
        t.job.save(); // Persist to server
      }
    });
  },

  // Support
  uploadFilesToJob: function() {
    var t = this,
        instanceSets = new captricity.api.InstanceSets;

    instanceSets.id = this.captricityJob.id;
    var totalSize = _.reduce(this.selectedFiles, function(sum, file) {
      return sum + file.size;
    }, 0);
    var totalCount = t.selectedFiles.length,
        totalDoneSize = 0,
        totalDoneCount = 0;
    _.each(t.selectedFiles, function(file) {
      var uploader = new captricity.MultipartUploader({
        'name': file.name,
        'multipage_file': file
      }, function(f, percent){
        console.log(f);
        if (percent > 99) {
          totalDoneSize += f.files.multipage_file.size;
          totalDoneCount++;
          var progress = Math.floor(100 * totalDoneSize / totalSize) + "%";
          console.log(progress);
          $('#upload-progress').css('width', progress).text(progress);
          $("#status").text(totalDoneCount + " / " + totalCount +
            " file(s) uploaded");
          if (totalDoneCount === totalCount) {
            t.uploadFinished();
          }
        }
      }, instanceSets.url(), 'POST');
    });
  },

  uploadFinished: function() {
    $("#submit-job").show();
    var Readiness = new captricity.api.JobReadiness({id: this.captricityJob.id}),
        Price = new captricity.api.JobPrice({id: this.captricityJob.id});
    Readiness.fetch({success: function(data) {
      console.log("Readiness", Readiness.attributes);
      if (Readiness.is_read_to_submit) {
        $("#readiness").text("Batch is ready to submit!");
      }
    }});
    Price.fetch({success: function(data) {
      console.log("Price", Price.attributes);
      var as = Price.attributes;
      $("#price").text("Will use " + as.user_pay_go_fields_applied + 
        " of " + as.user_pay_go_fields + " credits.");
    }});
    // Submit batch
  },
  generateBatchName: function() {
    return (Formidably.currentUser.organization.name + "|t" + 
      this.selectedTemplateId + "|" + window.timestamp());
  },
  filesAreValid: function() {
    // TODO
    return true;
  }
});