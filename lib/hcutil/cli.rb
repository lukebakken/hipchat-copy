#!/usr/bin/env ruby
# vim:ft=ruby:sw=2:ts=2

require 'thor'
require 'hcutil/version'
require 'hcutil/errors'
require 'hcutil/copier'
require 'hcutil/paster'

module HCUtil
  class CLI < Thor

    class_option(:verbose,
                 :desc => 'Verbose output',
                 :type => :boolean,
                 :aliases => '-v')

    class_option(:debug,
                 :desc => 'Debug output',
                 :type => :boolean)

    desc('version', 'show version')
    def version()
      puts("version: #{HCUtil::VERSION}")
    end

    desc('copy ROOM_NAME', 'copy chat messages from ROOM_NAME')
    option(:date,
           :desc => 'Date from which to copy messages',
           :type => :string,
           :aliases => '-d',
           :default => Time.now)
    option(:num_items,
           :desc => 'Number of chat messages to copy',
           :aliases => '-n',
           :type => :numeric,
           :default => 25)
    def copy(room_name)
      begin
        copier = HCUtil::Copier.new(room_name, options)
        copier.copy()
      rescue Errors::HCUtilError => e
        $stderr.puts("[error] #{e.message}")
      end
    end

    desc('paste THING', 'Paste from thing (- for stdin, a file if it is a valid filename, or literal string otherwise) into HipChat room')
    option(:room,
           :desc => 'HipChat room name or number into which to paste data',
           :type => :string,
           :aliases => '-r',
           :default => 61640)
    option(:ticket,
           :desc => 'Ticket number, optional. If present will create message header',
           :type => :numeric,
           :aliases => '-t')
    option(:summary,
           :desc => 'Summary, optional. If present will create message header',
           :type => :string,
           :aliases => '-s')
    def paste(thing)
      begin
        paster = HCUtil::Paster.new(thing, options)
        paster.paste()
      rescue Errors::HCUtilError => e
        $stderr.puts("[error] #{e.message}")
      end
    end
  end
end

