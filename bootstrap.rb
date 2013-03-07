#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

HOME      = Pathname.new ENV['HOME']
BACKUPS   = HOME + '.backups'
DOT_FILES = Pathname.new File.expand_path(File.dirname(__FILE__))

def debug(verbose, brief = nil)
  if ENV['DEBUG']
    puts verbose
  elsif brief
    print brief
  end
end

def dot_files(&block)
  Dir[DOT_FILES + 'dot-*'].each do |file|
    path      = Pathname.new file
    dot_file  = path.basename.to_s.sub(/\Adot-/, '.')
    debug "Found dot-file #{dot_file}", "#{dot_file}:"
    yield path.dirname + dot_file
  end
end

def delete(file_or_directory)
  if file_or_directory.exist?
    debug "Removing #{file_or_directory}", ' remove'
    FileUtils.rm_r file_or_directory, :force => true, :secure => true
  end
end

def backup(file_or_directory)
  if file_or_directory.exist? && !file_or_directory.symlink?
    BACKUPS.mkpath unless BACKUPS.exist?
    destination = BACKUPS + file_or_directory.basename
    delete destination
    debug "Moving #{file_or_directory} to #{destination}", ' backup'
    FileUtils.mv file_or_directory, destination, :force => true
  end
end

def link_dot_files
  dot_files do |file_or_directory|
    link = HOME + file_or_directory.basename
    backup link
    delete link
    debug "Symlinking #{file_or_directory} as #{link}", " link\n"
    FileUtils.ln_s file_or_directory, link
  end
end

Dir.chdir(HOME) do
  link_dot_files
end
