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

    scheme_dir.glob("*.{yaml,yml}").each do |scheme|
      basename = scheme.basename(scheme.extname).to_s
      if scheme_definitions.has_key?(basename)
        puts "Skipping: #{basename} (already exists)"
      else
        puts "Reading: #{scheme.basename}"
        scheme_definitions[basename] = YAML.load(scheme.read)
      end
    end
  end
end

banner "Updating template definitions"

templates = vendor.join("base16-templates")

raise "Target already exists" if templates_list.has_key?("nvim")
templates_list["nvim"] = "https://github.com/wincent/base16-nvim"

# Here we only care about a subset of templates.
["nvim", "shell", "vim"].each do |target|
  if templates_list.has_key?(target)
    url = templates_list[target]
    template_author_and_repo = url.
      sub(%r{\Ahttps://github\.com/}, '').
      sub(%r{\.git\z}, '')
    template_dir = templates.join("base16-#{target}")
    if template_dir.exist?
      puts "#{target}: updating"
      system("git", "-C", template_dir.to_s, "pull")
    else
      puts "#{target}: cloning"
      system("git", "-C", templates.to_s, "clone", url)
    end
  else
    puts "error: no metadata found for base16-#{target}"
  end
end

banner "Updating templates"

# One custom template (nvim) + two third-party ones.
{
  "nvim" => root.join("aspects/nvim/files/.config/nvim/colors"),
  "shell" => root.join("aspects/dotfiles/files/.zsh/colors"),
  "vim" => root.join("aspects/nvim/files/.vim/colors"),
}.each do |target, output_dir|
  puts "Reading: base16-#{target} config"
  template_dir = templates.join("base16-#{target}")
  template_config = YAML.load(template_dir.join("templates/config.yaml").read)

  # Could iterate over keys, but just assuming "default" for now.
  raise 'Missing "default" key' unless template_config.has_key?("default")
  raise 'Missing "extension" key' unless template_config["default"].has_key?("extension")

  extension = template_config["default"]["extension"]
  template = template_dir.join("templates/default.mustache").read
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
                  when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F)-hex\s*\z/
                    definition["base#{$~[1]}"]
                  when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F)-hex-([rgb])\s*\z/
                    definition["base#{$~[1]}"][
                      case $~[2]
                      when "r" then 0..1
                      when "g" then 2..3
                      when "b" then 4..5
                      end
                    ]
                  else
                    # See http://chriskempson.com/projects/base16/ for more
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
