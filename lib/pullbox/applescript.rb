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
      applescript = <<~APS.strip
        #{intro}
        display notification "#{message}" with title "#{title}"
      APS
      system "osascript -e '#{applescript}'"
    end

    def self.display_dialog(message, title, defaults = {})
      defaults = { answer: false, buttons: %w[OK] }.merge(defaults)
      answer = defaults[:answer] == true ? ' default answer ""' : ""
      buttons = 'buttons {"'
      buttons << defaults[:buttons].join('", "')
      buttons << "\"} default button \"#{defaults[:buttons].last}\""
      applescript = <<~APS.strip
        #{intro}
        try
          return text returned of (display dialog "#{message}"#{buttons}#{answer} with title "#{title}")
        on error errorMessage number errorNumber
          if errorNumber is equal to -128 -- aborted by user
            return ""
          end if
        end try
      APS
      answer = `osascript -e '#{applescript}'`.strip

      exit! if answer == ""

      answer
    end

    def self.export_playlist(name, to, format = :xml)
      allowed_formats = {
        m3u: "M3U",
        m3u8: "M3U8",
        plain_text: "plain text",
        unicode_text: "Unicode text",
        xml: "XML"
      }
      raise ArgumentError, "Export format not supported" unless allowed_formats.keys.include? format

      format = allowed_formats[format]
      applescript = <<~APS.strip
        #{intro}
        tell application "Music" to export playlist "#{name}" as #{format} to "#{to}"
      APS
      system "osascript -e '#{applescript}'"
    end
  end
end
