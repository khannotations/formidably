f = Organization.create!({
  name: "Formidably"
})

r = User.create!({
  first_name: "Rafi",
  last_name: "Khan",
  email: "rafi.khan@yale.edu",
  password: "rafikhan",
  password_confirmation: "rafikhan"
})

m = User.create!({
  first_name: "Megan",
  last_name: "Valentine",
  email: "megan.valentine@yale.edu",
  password: "meganvalentine",
  password_confirmation: "meganvalentine"
})

j = Job.create!({
  name: "WHO_contact_tracing",
  cid: 113311
})

r.confirmed_at = DateTime.now
r.save!

m.confirmed_at = DateTime.now
m.save!

f.users << r
f.users << m
f.jobs << j