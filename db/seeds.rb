# db/seeds.rb

puts "Seeding DevHub data..."

# Temporarily disable SolidQueue and run jobs inline while seeding,
# so we don't touch the solid_queue_jobs table (which doesn't exist in Render DB).
old_adapter = ActiveJob::Base.queue_adapter
ActiveJob::Base.queue_adapter = :inline

begin
  # WARNING: this will wipe existing data for training purposes.
  Task.destroy_all
  Project.destroy_all
  User.destroy_all

  # --- Users ---
  admin = User.create!(
    email: "auth-admin@test.com",
    password: "password",
    role: "admin"   # 👈 now this is really an admin in the app
  )

  owner = User.create!(
    email: "auth-owner@test.com",
    password: "password",
    role: "member"  # explicit, matches default
  )

  viewer = User.create!(
    email: "auth-viewer@test.com",
    password: "password",
    role: "member"  # explicit, matches default
  )

  puts "Users created: #{User.count}"
  puts "Admin user: #{admin.email} (role=#{admin.role})"
  puts "Owner user: #{owner.email} (role=#{owner.role})"
  puts "Viewer user: #{viewer.email} (role=#{viewer.role})"

  # --- Projects (no status column on Project) ---
  project1 = Project.create!(
    name: "Frontend Migration",
    description: "Migrate frontend to React + Apollo",
    owner: owner   # 👈 project owner: auth-owner@test.com
  )

  project2 = Project.create!(
    name: "Backend API Upgrade",
    description: "Refactor Rails API and GraphQL schema",
    owner: admin   # 👈 project owner: auth-admin@test.com
  )

  project3 = Project.create!(
    name: "Mobile App Redesign",
    description: "New UX for mobile client",
    owner: owner   # 👈 project owner: auth-owner@test.com
  )

  puts "Projects created: #{Project.count}"
  puts "Project1 owner: #{project1.owner.email if project1.owner}"
  puts "Project2 owner: #{project2.owner.email if project2.owner}"
  puts "Project3 owner: #{project3.owner.email if project3.owner}"

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
ensure
  # Restore original adapter when finished
  ActiveJob::Base.queue_adapter = old_adapter
end
