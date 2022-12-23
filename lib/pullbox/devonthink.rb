# frozen_string_literal: true

require_relative "applescript"

# Library for several classes
module Pullbox
  # DEVONthink AppleScript methods
  class DEVONthink
    def self.path_to_record(uuid)
      applescript = <<~APS.strip
        #{AppleScript.intro}
        tell application id "DNtp"
          set theRecord to get record with uuid "#{uuid}"
          if (type of theRecord as string) is not in {"group", "smart group", "tag"} then return (path of theRecord as string)
        end tell
      APS

      `osascript -e '#{applescript}'`.strip
    end

    def self.save_to_record(uuid, string)
      applescript = <<~APS.strip
        #{AppleScript.intro}
        tell application id "DNtp"
          set theRecord to get record with uuid "#{uuid}"
          set plain text of theRecord to "#{string}"
        end tell
      APS

      system "osascript -e '#{applescript}'"
    end

    def self.open(uuid)
      system "open '#{path_to_record(uuid)}'"
    end
  end
end
