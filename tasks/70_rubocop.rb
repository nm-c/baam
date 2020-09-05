# frozen_string_literal: true

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  task(:default).prerequisites << task(:rubocop)
rescue LoadError # rubocop:disable Lint/SuppressedException
end
