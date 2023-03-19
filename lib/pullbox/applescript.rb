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
      answer = defaults[:answer] ? ' default answer ""' : ""
      default_button = defaults[:buttons].last
      cancel_button = defaults[:buttons].first
      buttons = 'buttons {"'
      button_construct = buttons.dup
button_construct << defaults[:buttons].join('", "')
      button_construct << "\"} default button \"#{default_button}\" cancel button \"#{cancel_button}\""
      applescript = <<~APS.strip
        #{intro}
        try
          set theReturnedValue to (display dialog "#{message}" #{button_construct}#{answer} with title "#{title}")
          if button returned of theReturnedValue is "#{default_button}" then
            if text returned of theReturnedValue is not "" then
              return text returned of theReturnedValue
            else
              return
            end if
          end if
        on error errorMessage number errorNumber
          if errorNumber is equal to -128 -- aborted by user
            return
          end if
        end try
      APS
      answer = `osascript -e '#{applescript}'`.strip

      exit(0) if answer.empty?

      answer
    end

    def self.export_playlist(name, to, format = :xml)
      formats = {
        m3u: "M3U",
        m3u8: "M3U8",
        plain_text: "plain text",
        unicode_text: "Unicode text",
        xml: "XML"
      }

      applescript = <<~APS.strip
        #{intro}
        tell application "Music" to export playlist "#{name}" as #{formats.fetch(format, 'XML')} to "#{to}"
      APS
      system "osascript -e '#{applescript}'"
    end

    def self.applications_folder
      applescript = <<-APS.strip
        #{intro}

        set theApplicationsFolder to path to applications folder
        return (POSIX path) of theApplicationsFolder
      APS
      `osascript -e '#{applescript}'`.strip
    end

    def self.move_app(name, app_path, launch = true)
      applescript = <<-APS.strip
        #{intro}

        set theApplicationsFolder to path to applications folder
        try
          tell application "#{name}" to quit
        on error errMsg
        end try
        delay 3
        tell application "Finder"
          move (POSIX file "#{app_path}") as alias to theApplicationsFolder with replacing
        end tell
        if #{launch} then
          tell application "#{name}" to activate
        end if
      APS
      system "osascript -e '#{applescript}'"
    end
  end
end
