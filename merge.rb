#!/usr/bin/env ruby

require "simplecov"
require "simplecov-json"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

files = Dir["#{ENV['COVERAGE_PATH']}/**/*.json"]
puts "Merging files:"
files.each { |file| puts " - #{file}"}

puts "Working dir: #{Dir.getwd}"
system("find .")
SimpleCov.collate files, "rails" do
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::JSONFormatter,
      SimpleCov::Formatter::LcovFormatter,
      SimpleCov::Formatter::SimpleFormatter,
    ]
  )
end

if ENV.key?("GITHUB_OUTPUT")
  File.open(ENV["GITHUB_OUTPUT"], "w+") do |out|
    out.puts "json_path=#{SimpleCov.coverage_path}/coverage.json"
    out.puts "lcov_path=#{SimpleCov::Formatter::LcovFormatter.config.single_report_path}"
  end
end
