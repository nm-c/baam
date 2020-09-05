# frozen_string_literal: true

begin
  require 'dotenv/load'
rescue LoadError # rubocop:disable Lint/SuppressedException
end

Dir[File.expand_path('tasks/**/*.rb', __dir__)].sort.each do |file|
  require file
rescue LoadError # rubocop:disable Lint/SuppressedException
end
