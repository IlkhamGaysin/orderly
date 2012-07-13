require "orderly/version"

module Orderly
  RSpec::Matchers.define :appear_before do |later_content|
    match do |earlier_content|
      begin
        page.body.index(earlier_content) < page.body.index(later_content)
      rescue ArgumentError
        raise "Could not locate later content on page: #{later_content}"
      rescue
        raise "Could not locate earlier content on page: #{earlier_content}"
      end
    end
  end
end


## TODO: make sure this gets hooked into rspec when loaded into another project
