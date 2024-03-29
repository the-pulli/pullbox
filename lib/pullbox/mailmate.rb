# frozen_string_literal: true

require "net/http"
require "nokogiri"
require "plist"
require_relative "applescript"

module Pullbox
  class MailMate
    def self.beta_release
      mailmate = "#{Pullbox::AppleScript.applications_folder}MailMate.app/Contents/Info.plist"
      raise "MailMate not installed." unless File.exist? mailmate

      result = Plist.parse_xml(mailmate)
      raise "MailMate not properly installed." if result.nil?

      regexp1 = /\(r(?<number>\d+)\)/i
      regexp2 = /(?<number>\d+)/
      long_version = result["CFBundleGetInfoString"]
      version = long_version.match(regexp1)

      doc = Nokogiri::HTML(Net::HTTP.get(URI("https://updates.mailmate-app.com/archives/")))
      doc.xpath("/html/body/table/tr[position() = (last() - 1)]/td[2]/a/@href").each do |current_release|
        beta_version = current_release.value.match(regexp2)

        if beta_version[:number].to_i > version[:number].to_i
          response = Net::HTTP.get(URI("https://updates.mailmate-app.com/archives/#{current_release.value}"))
          File.write(current_release.value, response)
          system "tar -xjf #{current_release.value}"
          system "rm #{current_release.value}"
          path = "#{Dir.pwd}/MailMate.app"
          Pullbox::AppleScript.move_app("MailMate", path)
          Pullbox::AppleScript.display_notification("MailMate updated to version: #{beta_version[:number]}", "MailMate Updater")
        end
      end
    end
  end
end
