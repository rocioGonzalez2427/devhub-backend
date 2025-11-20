# db/seeds.rb

puts "Seeding DevHub data..."

# WARNING: this will wipe existing data for training purposes.
Task.destroy_all
Project.destroy_all
User.destroy_all

# --- Users ---
admin = User.create!(
  email: "auth-admin@test.com",
  password: "password"
)

owner = User.create!(
  email: "auth-owner@test.com",
  password: "password"
)

viewer = User.create!(
  email: "auth-viewer@test.com",
  password: "password"
)

puts "Users created: #{User.count}"

# --- Projects (no status column on Project) ---
project1 = Project.create!(
  name: "Frontend Migration",
  description: "Migrate frontend to React + Apollo"
)

project2 = Project.create!(
  name: "Backend API Upgrade",
  description: "Refactor Rails API and GraphQL schema"
)

project3 = Project.create!(
  name: "Mobile App Redesign",
  description: "New UX for mobile client"
)

puts "Projects created: #{Project.count}"

# --- Tasks ---
# We use status values expected by the app (e.g. pending, in_progress, done)
Task.create!(
  title: "Setup Apollo Client",
  description: "Configure Apollo Client and HTTP link",
  status: "pending",
  assignee: admin,
  project: project1
)

Task.create!(
  title: "Implement login mutation",
  description: "Wire up login form to /api/login and GraphQL",
  status: "in_progress",
  assignee: owner,
  project: project1
)

Task.create!(
  title: "Fix CORS issues",
  description: "Allow frontend Render origin and credentials",
  status: "done",
  assignee: admin,
  project: project2
)

Task.create!(
  title: "Refactor GraphQL schema",
  description: "Clean up types and add MyTasks query",
  status: "pending",
  assignee: viewer,
  project: project2
)

puts "Tasks created: #{Task.count}"
puts "Seeding completed!"
