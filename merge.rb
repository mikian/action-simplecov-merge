#!/usr/bin/env ruby

require "bundler"
require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "simplecov"
  gem "simplecov-json"
  gem "simplecov-lcov"
end

require "simplecov"
require "simplecov-json"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

puts "Merging files:"
files = Dir["#{ENV['COVERAGE_PATH']}/**/*.json", "#{ENV['COVERAGE_PATH']}/**/.*.json"].map do |file|
  puts " - #{file}"

  file
end

SimpleCov.collate files, "rails" do
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::JSONFormatter, SimpleCov::Formatter::LcovFormatter
  ])
end

if ENV.key?("GITHUB_OUTPUT")
  File.open(ENV["GITHUB_OUTPUT"], "w+") do |out|
    out.puts "json_path=#{SimpleCov.coverage_path}/coverage.json"
    out.puts "lcov_path=#{SimpleCov::Formatter::LcovFormatter.config.single_report_path}"
  end
end
