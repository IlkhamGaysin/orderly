require "orderly/version"
require "rspec/expectations"

module Orderly
  RSpec::Matchers.define :appear_before do |later_content, only_text: false|
    match do |earlier_content|
      begin
        node = page.respond_to?(:current_scope) ? page.current_scope : page.send(:current_node)
        data = only_text ? text_for_node(node) : html_for_node(node)

        data.index(earlier_content) < data.index(later_content)
      rescue ArgumentError
        raise "Could not locate later content on page: #{later_content}"
      rescue NoMethodError
        raise "Could not locate earlier content on page: #{earlier_content}"
      end
    end

    def html_for_node(node)
      if node.is_a?(Capybara::Node::Document)
        page.body
      elsif node.native.respond_to?(:inner_html)
        node.native.inner_html
      else
        page.driver.evaluate_script("arguments[0].innerHTML", node.native)
      end
    end

    def text_for_node(node)
      text = begin
        if node.is_a?(Capybara::Node::Document)
          page.text
        elsif node.native.respond_to?(:inner_html)
          node.native.inner_text
        else
          page.driver.evaluate_script("arguments[0].innerText", node.native)
        end
      end

      text.gsub(/[[:space:]]+/, ' ').strip
    end
  end
end
