#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

HOME      = Pathname.new ENV['HOME']
DOT_FILES = Pathname.new File.expand_path(File.dirname(__FILE__))

def dot_files
  @dot_files ||= Dir[DOT_FILES + 'dot-*'].map do |file|
    path      = Pathname.new file
    dot_file  = path.basename.to_s.sub(/\Adot-/, '.')
    puts "Found dot-file #{dot_file}"
    path.dirname + dot_file
  end
end

def delete_old_backup file
  if file.exist?
    puts "Removing old backup #{file}"
    FileUtils.rm file
  end
end

def backup file
  if file.exist?
    destination = "#{file}.bak"
    delete_old_backup destination
    puts "Backing up #{file} to #{destination}"
    FileUtils.mv file, destination, :force => true
  end
end

def link_dot_files
  dot_files.each do |file|
    link = HOME + file.basename
    backup link
    puts "Symlinking #{file} as #{link}"
    FileUtils.ln_sf file, link
  end
end

Dir.chdir(HOME) do
  link_dot_files
end
