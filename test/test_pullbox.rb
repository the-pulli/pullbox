# frozen_string_literal: true

require "test_helper"
require_relative "../lib/pullbox/applescript"

class TestPullbox < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pullbox::VERSION
  end

  def test_that_it_can_display_a_dialog
    mac_system { Pullbox::AppleScript.display_dialog("Hello", "MailMate", buttons: %w[Cancel OK]) }
  end

  private

  def mac_system
    return unless block_given?

    osascript = `which osascript`
    yield if osascript.length.positive?
  end
end
