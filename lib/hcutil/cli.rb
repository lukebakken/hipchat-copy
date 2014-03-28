#!/usr/bin/env ruby
# vim:ft=ruby:sw=2:ts=2

require 'thor'
require 'hcutil/version'

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

    desc('copy ROOM', 'copy chat messages from ROOM')
    option(:date,
           :desc => 'Date from which to copy messages',
           :type => :string,
           :aliases => '-d',
           :default => Time.now.to_s)
    option(:num_items,
           :desc => 'Number of chat messages to copy',
           :aliases => '-n',
           :type => :numeric,
           :default => 25)
    def copy(room)
      puts("COPYING FROM #{room}")
    end
  end
end

