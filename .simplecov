require 'simplecov'
require 'simplecov-lcov'
require 'simplecov-table'

SimpleCov.coverage_dir '.coverage'
SimpleCov.add_filter ['node_modules', 'test']

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.single_report_path = '.coverage/lcov.info'
  c.report_with_single_file = true
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter,
  SimpleCov::Formatter::TableFormatter,
])

# vim:ft=ruby
