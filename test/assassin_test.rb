# -*- encoding : utf-8 -*-
require 'testing'
require 'assassin'
require 'yaml'

Testing Assassin do
  testing 'that not using assassin.rb leaks zombie processes' do
    assert do
      parent_pid, child_pid = `#{ TESTDIR }/parent.rb`.scan(/\d+/).map(&:to_i)

      parent_was_killed = false
      child_was_killed = false

      10.times do
        begin
          Process.kill(0, parent_pid)
          sleep(rand)
        rescue Errno::ESRCH
          parent_was_killed = true
          break
        end
      end

      10.times do
        begin
          Process.kill(0, child_pid)
          sleep(rand)
        rescue Errno::ESRCH
          child_was_killed = true
          break
        end
      end

      cleanup!(parent_pid, child_pid)

      parent_was_killed && !child_was_killed
    end
  end

  testing 'that __using__ assassin.rb does __not__ leak zombie processes' do
    assert do
      parent_pid, child_pid = `#{ TESTDIR }/parent.rb assassin`.scan(/\d+/).map(&:to_i)

      parent_was_killed = false
      child_was_killed = false

      10.times do
        begin
          Process.kill(0, parent_pid)
          sleep(rand)
        rescue Errno::ESRCH
          parent_was_killed = true
          break
        end
      end

      10.times do
        begin
          Process.kill(0, child_pid)
          sleep(rand)
        rescue Errno::ESRCH
          child_was_killed = true
          break
        end
      end

      cleanup!(parent_pid, child_pid)

      parent_was_killed && child_was_killed
    end
  end

protected

  def cleanup!(*pids)
    pids.flatten.compact.each do |pid|
      pid = pid.to_s.to_i
      begin
        Process.kill(9, pid) rescue nil
        Process.kill(-9, pid) rescue nil
        `kill -9 #{ pid } 2>&1`
      rescue
      end
    end
  end
end






BEGIN {
  TESTDIR = File.dirname(File.expand_path(__FILE__))
  TESTLIBDIR = File.join(TESTDIR, 'lib')
  ROOTDIR = File.dirname(TESTDIR)
  LIBDIR = File.join(ROOTDIR, 'lib')
  $LOAD_PATH.push(LIBDIR)
  $LOAD_PATH.push(TESTLIBDIR)
}
