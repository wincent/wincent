#!/usr/bin/env ruby

# Markdownifying wrapper around msmtp.
#
# Run with:
#
#   env BUNDLE_GEMFILE=$HOME/.mutt/scripts/Gemfile $HOME/.mutt/scripts/msmtp.rb ARGS...

require 'open3'

MSMTP_PATH = '/usr/local/bin/msmtp'

# Transform Markdown string `source` into an HTML string.
#
# On failure returns nil.
def markdown(source)
  Open3.popen2('pandoc', '-s', '-f', 'markdown', '-t', 'html') do |stdin, stdout, wait_thr|
    stdin.puts(source)
    stdin.close
    stdout.read
  end
rescue => e
  STDERR.puts e
  nil
end

# Trims the "!m" marker string from the beginning or end of the input. Returns
# true if the input was trimmed.
def trim_markdown_markers!(input)
  trimmed = !!input.sub!(MARKDOWN_MARKER_AT_START, '')
  !!input.sub!(MARKDOWN_MARKER_AT_END, '') || trimmed
end

MARKDOWN_MARKER_AT_START = /\A\s*^[ \t]*!m[ \t]*$/
MARKDOWN_MARKER_AT_END = /^[ \t]*!m[ \t]*$\s*\z/

def process_leaf(part)
  if part.content_type =~ %r{\Atext/plain\b} && part.content_disposition == 'inline'
    # This is UTF-8, at least on my system, even if part.body.charset is
    # something different like US-ASCII or undefined.
    content = part.decoded
    if trim_markdown_markers!(content)
      part.body = content
      if html = markdown(content)
        html_part = Mail::Part.new
        html_part.content_type = 'text/html'
        html_part.body = html
        return html_part
      end
    end
  end
end

def process_part(part)
  found_markdown_part = false
  if part.multipart?
    if part.content_type !~ %r{\Amultipart/signed\b}
      if part.parts.none? { |subpart| subpart.content_type =~ %r{\Atext/html\b} }
        part.parts.each do |subpart|
          if subpart.multipart?
            found_markdown_part ||= process_part(subpart)
          else
            if html_part = process_leaf(subpart)
              part.add_part(html_part)
              found_markdown_part = true
            end
          end
        end
      end
    end
  else
    if html_part = process_leaf(part)
      part.add_part(html_part)
      return true
    end
  end

  found_markdown_part
end

def process
  input = STDIN.read
  mail = Mail.new(input)
  if process_part(mail)
    mail.encoded
  else
    input
  end
end

def deliver(message)
  Open3.popen2(MSMTP_PATH, *ARGV) do |stdin, stdout, wait_thr|
    stdin.puts(message)
    stdin.close
    puts stdout.read
  end
end

def passthrough
  STDERR.puts 'Running in passthrough mode.'
  exec MSMTP_PATH, *ARGV
end

begin
  require 'rubygems'
  require 'bundler/setup'
  require 'mail'
rescue LoadError => e
  STDERR.puts e
  passthrough
end

deliver(process)
