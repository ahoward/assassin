#! /usr/bin/env ruby

#
  STDOUT.sync = true
  STDERR.sync = true
  puts Process.pid

#
  TESTDIR = File.dirname(__FILE__)
  ROOTDIR = File.dirname(TESTDIR)
  LIBDIR = File.join(ROOTDIR, 'lib')

#
  child_program = "#{ TESTDIR }/child.rb"
  child = IO.popen(child_program)
  puts child.pid

#
  if ARGV.first.to_s =~ /assassin/
    require "#{ LIBDIR }/assassin.rb"
    Assassin.at_exit_kill(child.pid)
  end

#
  exit!
