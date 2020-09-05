# frozen_string_literal: true

begin
  require 'dotenv/load'
rescue LoadError # rubocop:disable Lint/SuppressedException
end

begin
  require 'bundler/gem_tasks'
rescue LoadError # rubocop:disable Lint/SuppressedException
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task(:default).prerequisites << task(:spec)
rescue LoadError # rubocop:disable Lint/SuppressedException
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  task(:default).prerequisites << task(:rubocop)
rescue LoadError # rubocop:disable Lint/SuppressedException
end
