#!/usr/bin/env ruby
# vim:ft=ruby:sw=2:ts=2

require 'thor'
require 'hcutil/version'
require 'hcutil/copier'

module HCUtil
  class CLI < Thor

    class_option(:room,
           :desc => 'HipChat room with which to work',
           :aliases => '-r',
           :type => :string,
           :default => 'Client Services')

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
      rescue AuthError, CopierError => e
        $stderr.puts("[error] #{e.message}")
      end
    end
  end
end

