require "bundler/gem_tasks"
require 'rake/version_task'

Rake::VersionTask.new do |task|
  task.with_git_tag = true
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r hive/messages.rb"
end
