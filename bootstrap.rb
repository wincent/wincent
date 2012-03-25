#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

HOME      = Pathname.new ENV['HOME']
DOT_FILES = Pathname.new File.expand_path(File.dirname(__FILE__))

def dot_files
  Dir[DOT_FILES + 'dot-*'].map do |file|
    path      = Pathname.new file
    dot_file  = path.basename.to_s.sub(/\Adot-/, '.')
    puts "Found dot-file #{dot_file}"
    path.dirname + dot_file
  end
end

def delete file_or_directory
  if file_or_directory.exist?
    puts "Removing #{file_or_directory}"
    FileUtils.rm_r file_or_directory, :force => true, :secure => true
  end
end

def backup file_or_directory
  if file_or_directory.exist? && !file_or_directory.symlink?
    destination = file_or_directory.sub /\z/, '.bak'
    delete destination
    puts "Moving #{file_or_directory} to #{destination}"
    FileUtils.mv file_or_directory, destination, :force => true
  end
end

def link_dot_files
  dot_files.each do |file_or_directory|
    link = HOME + file_or_directory.basename
    backup link
    delete link
    puts "Symlinking #{file_or_directory} as #{link}"
    FileUtils.ln_s file_or_directory, link
  end
end

Dir.chdir(HOME) do
  link_dot_files
end
