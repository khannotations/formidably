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
    "click #submit-batch": "submitBatch"
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
    this.batch = new captricity.api.Batch();
    var t = this;
    this.batch.save({
      name: this.generateBatchName(),
      documents: [this.selectedTemplateId],
    }, {
      success: function() {
        var batchFiles = new captricity.api.BatchFiles();
        batchFiles.batch_id = t.batch.id;
        var totalSize = _.reduce(t.selectedFiles, function(sum, file) {
          return sum + file.size;
        }, 0);
        console.log(t.batch, "batch");
        var totalCount = t.selectedFiles.length,
            totalDoneSize = 0,
            totalDoneCount = 0;
        _.each(t.selectedFiles, function(file) {
          var uploader = new captricity.MultipartUploader({
            'file_name': file.name,
            'uploaded_file': file
          }, function(f, percent){
            if (percent > 99) {
              totalDoneSize += f.files.uploaded_file.size;
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
          }, batchFiles.url());
        });
      },
      error: function() {
        console.log("error");
      }
    })
  },

  submitBatch: function() {
    var t = this;
    console.log("before", this.batch.related_job_id);
    captricity.apiPost(captricity.url.submitBatch(this.batch.id), {
      success: function(batch) {
        console.log("after", batch, t.batch.related_job_id);
        console.log("batch submit success");
      }
    });
  },

  // Support
  uploadFinished: function() {
    $("#submit-batch").show();
    var Readiness = new captricity.api.BatchReadiness({id: this.batch.id}),
        Price = new captricity.api.BatchPrice({id: this.batch.id});
    Readiness.fetch({success: function(data) {
      console.log("Readiness", Readiness.attributes);
      if (Readiness.attributes.errors.length) {
        $("#readiness").text("Batch is not ready to be processed. " + 
          "Check logs for errors.");
        console.log("Readiness errors:", Readiness.attributes.errors);
      } else {
        $("#readiness").text("Batch is ready for processing!");
      }
    }});
    Price.fetch({success: function(data) {
      console.log("Price", Price.attributes);
      var as = Price.attributes;
      $("#price").text("Will use " + as.user_pay_go_fields_applied + 
        " of " + as.user_pay_go_fields + " credits.");
    }});
    alert("upload finished!");
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