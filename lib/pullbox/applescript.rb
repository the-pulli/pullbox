# frozen_string_literal: true

# Library for several classes
module Pullbox
  # Applescript wrapper
  class AppleScript
    def self.intro
      <<~APS.strip
        use AppleScript version "2.4" -- Yosemite (10.10) or later
        use scripting additions

      APS
    end

    def self.display_notification(message, title)
      apple_script = <<~APS.strip
        #{intro}
        display notification "#{message}" with title "#{title}"
      APS
      system "osascript -e '#{apple_script}'"
    end

    def self.display_dialog(message, title, defaults = {})
      defaults = { answer: false, buttons: %w[OK] }.merge(defaults)
      answer = defaults[:answer] == true ? ' default answer ""' : ''
      buttons = 'buttons {"'
      buttons << defaults[:buttons].join('", "')
      buttons << "\"} default button \"#{defaults[:buttons].last}\""
      apple_script = <<~APS.strip
        #{intro}
        try
          return text returned of (display dialog "#{message}"#{buttons}#{answer} with title "#{title}")
        on error errorMessage number errorNumber
          if errorNumber is equal to -128 -- aborted by user
            return ""
          end if
        end try
      APS
      answer = `osascript -e '#{apple_script}'`.strip

      exit! if answer == ''

      answer
    end
  end
end
