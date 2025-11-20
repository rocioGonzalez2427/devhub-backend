# db/seeds.rb

puts "Seeding DevHub data..."

User.destroy_all
Project.destroy_all
Task.destroy_all

# --- Users ---
admin = User.create!(
  email: "auth-admin@test.com",
  password: "password",
  role: :admin
)

owner = User.create!(
  email: "auth-owner@test.com",
  password: "password",
  role: :owner
)

viewer = User.create!(
  email: "auth-viewer@test.com",
  password: "password",
  role: :viewer
)

puts "Users created: #{User.count}"

# --- Projects ---
project1 = Project.create!(name: "Frontend Migration", status: :active)
project2 = Project.create!(name: "Backend API Upgrade", status: :active)
project3 = Project.create!(name: "Mobile App Redesign", status: :archived)

puts "Projects created: #{Project.count}"

# --- Tasks ---
Task.create!(
  title: "Setup Apollo Client",
  status: :open,
  assignee: admin,
  project: project1
)

Task.create!(
  title: "Implement login mutation",
  status: :in_progress,
  assignee: owner,
  project: project1
)

Task.create!(
  title: "Fix CORS issues",
  status: :done,
  assignee: admin,
  project: project2
)

Task.create!(
  title: "Refactor GraphQL schema",
  status: :open,
  assignee: viewer,
  project: project2
)

puts "Tasks created: #{Task.count}"

puts "Seeding completed!"
