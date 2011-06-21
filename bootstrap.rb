#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

HOME      = Pathname.new ENV['HOME']
PERSONAL  = HOME + 'personal/unversioned'
WORK      = HOME + 'work/unversioned'
DOT_FILES = PERSONAL + 'wincent.git'

def system_or_die *args
  unless system *args
    raise RuntimeError, "command #{args.inspect} exited with status #{$?.exitstatus}"
  end
end

def create_directories
  FileUtils.mkdir_p PERSONAL
end

def clone_repo
  return if DOT_FILES.exist?
  system_or_die 'git', 'clone', 'git://git.wincent.com/wincent.git', DOT_FILES
end

def dot_files
  @dot_files ||= Dir[DOT_FILES + 'dot-*'].map do |file|
    path      = Pathname.new file
    dot_file  = path.basename.to_s.sub(/\Adot-/, '.')
    puts "Found dot-file #{dot_file}"
    path.dirname + dot_file
  end
end

def backup file
  if file.exist?
    destination = "#{file}.bak"
    puts "Backing up #{file} to #{destination}"
    FileUtils.mv file, destination, :force => true
  end
end

def link_dot_files
  dot_files.each do |file|
    backup file
    link = HOME + file.basename
    puts "Symlinking #{file} as #{link}"
    FileUtils.ln_sf file, link
  end
end

Dir.chdir(HOME) do
  create_directories
  clone_repo
  link_dot_files
end
