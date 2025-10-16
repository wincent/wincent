#!/usr/bin/env ruby

require 'shellwords'

module DSL
  module Constants
    Backslash = '\\'
    Enter = 'Enter'
    Space = 'Space'
  end

  class << self
    def escape(string)
      Shellwords.shellescape(string)
    end
  end

  class Session
    WAIT_TIMEOUT = 5

    def initialize(name)
      @name = name
    end

    def send_keys(*args)
      escaped = args.map { |arg| DSL.escape(arg) }
      %x{tmux send-keys -t #{@name} #{escaped.join(' ')}}
    end

    def wait_for(pattern)
      buffer = nil
      start = Time.now
      while (Time.now - start < WAIT_TIMEOUT)
        %x{tmux capture-pane -t #{@name}}
        buffer = %x{tmux show-buffer}
        %x{tmux delete-buffer}
        return buffer if buffer =~ pattern
        sleep 0.25
      end
      raise "Failed to find pattern `#{pattern.inspect}` in session `#{@name}`"
    end
  end

  def session(name, &block)
    escaped_name = DSL.escape(name)
    %x{tmux new-session -d -s #{DSL.escape(escaped_name)} -y 20}
    Session.new(escaped_name).instance_eval(&block)
    %x{tmux kill-session -t #{escaped_name}}
  end
end
self.extend(DSL)
Object.instance_eval { include DSL::Constants }

session('ferret-test') do |name|
  send_keys('vim -u NONE -N', Enter)
  send_keys(':set shortmess+=A', Enter)
  send_keys(":set runtimepath+=#{DSL.escape(Dir.pwd)}", Enter)
  send_keys(':runtime! plugin/ferret.vim', Enter)
  send_keys(Backslash, 'a', 'usr/bin/env', Backslash, Space, 'ruby', Enter)
  wait_for(/module DSL/)
  send_keys(':quitall!', Enter)
end
