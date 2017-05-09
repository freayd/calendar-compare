#!/usr/bin/env ruby

require 'optparse'

require 'rubygems'
require 'bundler/setup'
require 'icalendar'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] file"

  opts.on('-u', '--update-timestamp', 'Update DTSTAMP fields') do |u|
    options[:update_timestamp] = u
  end
end.parse!

input_file = ARGV[0]
abort('Missing file argument') unless input_file

module Icalendar
  class Component
    private
    def ical_components
      collection = []
      (self.class.components + custom_components.keys).each do |component_name|
        components = send component_name
        components.each do |component|
          collection << component.to_ical
        end
      end
      collection.sort! # HACK: Added line that sort data
      collection.empty? ? nil : collection.join.chomp("\r\n")
    end
  end
end

Icalendar::Calendar.parse(File.open(input_file)).each do |calendar|
  if options[:update_timestamp]
    calendar.events.each do |event|
      event.dtstamp = Time.now.utc
    end
  end

  puts calendar.to_ical
end
