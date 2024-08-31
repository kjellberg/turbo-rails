if (cable_config_path = Rails.root.join("config/cable.yml")).exist?
  say "Enable redis in bundle"

  gemfile_path = ENV["BUNDLE_GEMFILE"] || Rails.root.join("Gemfile")
  gemfile_content = File.read(gemfile_path)
  pattern = /gem ['"]redis['"]/

  if gemfile_content.match?(pattern)
    uncomment_lines gemfile_path, pattern
  else
    append_file gemfile_path, "\n# Use Redis for Action Cable"
    gem 'redis', '~> 4.0'
  end

  run_bundle

  say "Switch development cable to use redis"
  gsub_file cable_config_path.to_s, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
else
  say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
end
