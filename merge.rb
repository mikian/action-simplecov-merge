#!/usr/bin/env ruby

require "simplecov"
require "simplecov-json"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

# Find and normalise all covergae files
puts "Normalise paths #{WORKSPACE} -> #{ENV["GITHUB_WORKSPACE"]}"
puts "Merging files:"
files = Dir["#{ENV['COVERAGE_PATH']}/**/*.json"].map do |file|
  puts " - #{file}"
  coverage = File.read(file).gsub(%r{#{ENV["WORKSPACE"]}}, ENV["GITHUB_WORKSPACE"])
  File.open(file, "wb") { |io| io.write(coverage) }

  file
end

SimpleCov.collate files, "rails" do
  formatters = [
    SimpleCov::Formatter::JSONFormatter, SimpleCov::Formatter::LcovFormatter
  ]
end

if ENV.key?("GITHUB_OUTPUT")
  File.open(ENV["GITHUB_OUTPUT"], "w+") do |out|
    out.puts "json_path=#{SimpleCov.coverage_path}/coverage.json"
    out.puts "lcov_path=#{SimpleCov::Formatter::LcovFormatter.config.single_report_path}"
  end
end
