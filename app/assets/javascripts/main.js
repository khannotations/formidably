// "use strict";

// $(document).ready(function() {
//   var selectedTemplateId = 0;
//   $(".js-template").click(function() {
//     $(".js-template.selected").removeClass("selected");
//     console.log($(this).data("id"));
//     $(this).addClass("selected");
//     selectedTemplateId = $(this).data("id");
//   })

//   // Submit button
//   var batchId;
//   $("#upload-submit").click(function(e) {
//     initFileUpload();
//     var fileList = $("#uploadfiles")[0].files;
//     if (!selectedTemplateId) {
//       alert("Please choose a template!");
//       return false;
//     }
//     if (!fileList || !fileList.length) {
//       alert("Please choose files!");
//       return false;
//     }
//     // Create a new batch
//     $.post("/batch", {template_id: selectedTemplateId}, function(data) {
//       console.log("postback", data);
//       batchId = data.id;
//       if (batchId) {
//         console.log("uploading to ", batchId);
//         // Add form data
//         $("#uploadfiles").fileupload({formData: { batch_id: batchId }});
//         // Upload files
//         $("#uploadfiles").fileupload('add', {files: fileList});
//       }
//     });
//   });

//   function initFileUpload() {
//     $("#uploadfiles").fileupload({
//       autoUpload: false,
//       acceptFileTypes: /\.pdf$/i,
//       dataType: 'json',
//       limitMultiFileUploadSize: 10, // 10 MB max file size
//       limitMultiFileUploads: 3,
//       uploadTemplateId: null,
//       downloadTemplateId: null,
//       add: function(e, data) {
//         console.log("add", data.formData);
//         data.submit();
//       },
//       progressall: function (e, data) {
//         var progress = parseInt(data.loaded / data.total * 100, 10) + '%';
//         $('#upload-progress').css('width', progress).text(progress);
//       },
//       // Destroy when done. 
//       done: function() {
//         console.log("done");
//         batchId = null;
//         $('#uploadfiles').fileupload('destroy');
//       },
//     });
//     console.log("inited");
//   }
// });