#!/usr/bin/env ruby

require "simplecov"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

SimpleCov.collate Dir["#{ENV['COVERAGE_PATH']}/*.json"], "rails" do
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::LcovFormatter
    ]
  )
end

File.open(ENV["GITHUB_OUTPUT"], "w+") do |out|
  out.puts "lcov_path=#{SimpleCov::Formatter::LcovFormatter.config.single_report_path}"
end
