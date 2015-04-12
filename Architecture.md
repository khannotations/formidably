## Workflow

User logs into Formidably with email / password
- Must belong to organization? 
User is shown dashboard with recently submitted jobs by the organization

User chooses to "upload"
User sees screen with all possible templates; chooses one
=> get_templates
User is shown form upload
User chooses file(s) / folder to upload
  Files are uploaded fault tolerantly
  - new batch is created
  - progress bar is shown
  Job is submitted with new batch and template
  User is given status message
  - Email notification?

Batch is created on file submit
Batch is submitted on file complete. 
-> There may be orphaned batches that are created but not submitted. 
-> Dashboard should show that. 

Workflow: 

### Submit Jobs
-> Files chosen, "submit" is clicked. 
-> Job is created on Captricity
  -> Callback: job is created on Formidably

<!-- -> Batch is created on Captricity
  -> Callback: batch is created on Formidably.  -->
-> Files are uploaded to Captricity
  -> HTTPS keeps HIPAA compliance; Formidably servers never see the files.
-> On file complete, job is submitted
  -> Callback: job is marked as submitted on Formidably. 
  -> Associated job is not created right away

### Get Jobs
-> Get all jobs from Formidably
-> Get all jobs from Captricity
-> Compare ids and find ones that belong to organization
-> Save them..?

Back to upload screen to upload more files

User chooses to "download"
User sees screen to filter / download relevant data

(Background) Job is finished
Data is downloaded to organization



## Data architecture

#### Organization

- Name
- Description
- has_may :users

#### User

- Name
- Email
- Password

#### Batch

(corresponds with a Captricity Batch)

- belongs_to :organization
- cid (captricity id)