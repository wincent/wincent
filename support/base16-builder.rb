#!/usr/bin/env ruby

require "fileutils"
require "io/console"
require "pathname"
require "strscan"
require "yaml"

base = Pathname.new(__dir__)
root = base.join("..")
vendor = root.join("vendor")
schemes_list = YAML.load(vendor.join("base16-schemes-source/list.yaml").read)
templates_list = YAML.load(vendor.join("base16-templates-source/list.yaml").read)

def banner(msg)
  width = IO.console.winsize[1]
  puts
  puts "#" * width
  puts "# " + msg + " " * [0, width - msg.length - 4].max + " #"
  puts "#" * width
  puts
end

def obliterate_crypto_casino_links(text)
  text.gsub('(http://chriskempson.com)', '(https://github.com/chriskempson)')
end

banner "Updating schema definitions"

scheme_definitions= {}

schemes_list.each do |name, url|
  if url !~ %r{\Ahttps://github\.com/}
    puts "#{name}: skipping (unsupported format: #{url})"
  else
    scheme_author_and_repo = url.
      sub(%r{\Ahttps://github\.com/}, '').
      sub(%r{\.git\z}, '')
    schemes = vendor.join("base16-schemes")
    scheme_dir = schemes.join(scheme_author_and_repo)
    unless ENV['NO_CLONE'] == 1
      if scheme_dir.exist?
        puts "#{name}: updating #{scheme_author_and_repo}"
        system("git", "-C", scheme_dir.to_s, "pull")
      else
        puts "#{name}: cloning #{scheme_author_and_repo}"
        author = scheme_author_and_repo.split('/').first
        author_dir = schemes.join(author)
        author_dir.mkpath
        system("git", "-C", author_dir.to_s, "clone", url)
      end
    end

    scheme_dir.glob("*.{yaml,yml}").each do |scheme|
      basename = scheme.basename(scheme.extname).to_s
      if scheme_definitions.has_key?(basename)
        puts "Skipped: #{basename} (already exists)"
      else
        data = YAML.load(scheme.read)
        if data['scheme'].is_a?(String) && data['author'].is_a?(String) && data['base00'].is_a?(String)
          puts "Read: #{scheme.basename}"
          data['author'] = obliterate_crypto_casino_links(data['author'])
          scheme_definitions[basename] = data
        else
          # Needed for repos like stepchowfun/base16-circus-scheme, which has
          # "circus.yaml" (a scheme) and "toast.yml" (not a scheme).
          puts "Skipped: #{basename} (not a scheme definition)"
        end
      end
    end
  end
end

banner "Updating template definitions"

templates = vendor.join("base16-templates")

# Here we only care about a subset of templates.
["iterm2", "kitty", "nvim", "shell", "vim"].each do |target|
  if templates_list.has_key?(target)
    url = templates_list[target]
    template_author_and_repo = url.
      sub(%r{\Ahttps://github\.com/}, '').
      sub(%r{\.git\z}, '')
    template_dir = templates.join("base16-#{target}")
    unless ENV['NO_CLONE'] == 1
      if template_dir.exist?
        puts "#{target}: updating clone #{template_dir}"
        system("git", "-C", template_dir.to_s, "pull")
      else
        puts "#{target}: cloning into #{template_dir}"
        system("git", "-C", templates.to_s, "clone", url)
      end
    end
  else
    puts "error: no metadata found for base16-#{target}"
  end
end

banner "Updating templates"

# One custom template (nvim) + four third-party ones.
{
  "iterm2" => root.join("vendor/base16-iterm2"),
  "kitty" => root.join("aspects/dotfiles/files/.config/kitty/colors"),
  "nvim" => root.join("aspects/nvim/files/.config/nvim/pack/bundle/opt/base16-nvim/colors"),
  "shell" => root.join("aspects/dotfiles/files/.zsh/colors"),
  "vim" => root.join("aspects/nvim/files/.vim/colors"),
}.each do |target, output_dir|
  puts "Reading: base16-#{target} config"
  template_dir = templates.join("base16-#{target}")
  template_config = YAML.load(template_dir.join("templates/config.yaml").read)

  template_config.keys.each do |name|
    raise 'Missing "extension" key' unless template_config[name].has_key?("extension")
    extension = template_config[name]["extension"]
    template = template_dir.join("templates/#{name}.mustache").read
    template = obliterate_crypto_casino_links(template)
    scheme_definitions.each do |slug, definition|
      output = ""
      scanner = StringScanner.new(template)
      while !scanner.eos?
        content = scanner.scan_until(/\{\{/)
        if content.nil?
          output += scanner.rest
          break
        else
          output += content[0..-3] # Trim off "{{".
          interpolation = scanner.scan_until(/\}\}/)
          raise "error: unterminated interpolation (}})" if interpolation.nil?
          interpolation = interpolation[0..-3] # Trim off "}}".
          output += case interpolation
                    when /\A\s*scheme-author\s*\z/
                      definition["author"]
                    when /\A\s*scheme-name\s*\z/
                      definition["scheme"]
                    when /\A\s*scheme-slug\s*\z/
                      slug
                    when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F)-dec-([rgb])\s*\z/
                      case $~[2]
                      when "r" then (definition["base#{$~[1]}"][0..1].to_i(16) / 255.0).to_s
                      when "g" then (definition["base#{$~[1]}"][2..3].to_i(16) / 255.0).to_s
                      when "b" then (definition["base#{$~[1]}"][4..5].to_i(16) / 255.0).to_s
                      end
                    when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F)-hex\s*\z/
                      definition["base#{$~[1]}"]
                    when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F)-hex-([rgb])\s*\z/
                      case $~[2]
                      when "r" then definition["base#{$~[1]}"][0..1].to_s
                      when "g" then definition["base#{$~[1]}"][2..3].to_s
                      when "b" then definition["base#{$~[1]}"][4..5].to_s
                      end
                    else
                      # See https://github.com/chriskempson/base16 for more
                      # possibilities, which I'll implement only if needed.
                      raise "error: unrecognized interpolation (#{interpolation.inspect})"
                    end
        end
      end
      output_file = output_dir.join("base16-#{slug}#{extension}")
      if output_file.exist?
        current_contents = output_file.read
        if output != current_contents
          puts "Writing: #{output_file}"
          output_file.write(output)
        else
          puts "Up-to-date: #{output_file}"
        end
      else
        puts "Creating: #{output_file}"
        output_file.write(output)
      end
    end
  end
end
