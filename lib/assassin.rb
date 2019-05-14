require 'tmpdir'
require 'securerandom'

class Assassin
  Version = '1.4.2' unless defined?(Version)

  def Assassin.version
    Version
  end

  def Assassin.description
    'no zombies ever, not even on `exit!` or `kill -9`'
  end

  def Assassin.at_exit_kill(*args, &block)
    new(*args, &block)
  end

  def Assassin.ate(*args, &block)
    new(*args, &block)
  end

  attr_accessor :parent_pid
  attr_accessor :child_pid
  attr_accessor :pid
  attr_accessor :path

  def initialize(child_pid, options = {})
    @child_pid = child_pid.to_s.to_i
    @parent_pid = Process.pid
    @options = Assassin.options_for(options)
    @pid, @path = Assassin.generate(@child_pid, @options)
  end

  def Assassin.options_for(options)
    options.inject({}){|h, kv| k,v = kv; h.update(k.to_s.to_sym => v)}
  end

  def Assassin.generate(child_pid, options = {})
    path = File.join(Dir.tmpdir, "assassin-#{ child_pid }-#{ SecureRandom.uuid }.rb")
    script = Assassin.script_for(child_pid, options)
    IO.binwrite(path, script)
    pid = Process.spawn "ruby #{ path }"
    [pid, path]
  end

  def Assassin.script_for(child_pid, options = {})
    parent_pid = Process.pid
    delay = (options[:delay] || 0.42).to_f

    script = <<-__
      Process.daemon

      require 'fileutils'
      at_exit{ FileUtils.rm_f(__FILE__) }

      parent_pid = #{ parent_pid }
      child_pid = #{ child_pid }
      delay = #{ delay }

      m = 24*60*60
      n = 42
      
      m.times do
        begin
          Process.kill(0, parent_pid)
        rescue Object => e
          sleep(delay)

          if e.is_a?(Errno::ESRCH)
            n.times do
              begin
                Process.kill(15, child_pid) rescue nil
                sleep(rand + rand)
                Process.kill(9, child_pid) rescue nil
                sleep(rand + rand)
                Process.kill(0, child_pid)
              rescue Errno::ESRCH
                break
              end
            end
          end

          exit
        end

        sleep(1)
      end
    __

    return script
  end
end
