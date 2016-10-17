#! /usr/bin/env ruby
 
#
  STDOUT.sync = true
  STDERR.sync = true
  puts Process.pid rescue nil

#
  loop{ sleep }
