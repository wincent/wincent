#!/usr/bin/env ruby

require "fileutils"
require "io/console"
require "pathname"
require "strscan"
require "yaml"

base = Pathname.new(__dir__)
root = base.join("..")
vendor = root.join("vendor")
schemes = vendor.join("tinted-theming/schemes/base16").glob("*.yaml")
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

def no_fetch?(author_and_repo)
  return true if ENV['NO_CLONE'] == 1
  return true if author_and_repo =~ %r{\Aaramisgithub/}
end

banner "Updating schema definitions"

scheme_definitions= {}

schemes.each do |scheme_definition|
  slug = scheme_definition.basename.sub_ext("")
  data = YAML.load_file(scheme_definition)
  if data["system"] == "base16"
    puts "Read: #{slug}"
    scheme_definitions[slug] = data['palette']
    scheme_definitions[slug]['author'] = obliterate_crypto_casino_links(data['author'])
    scheme_definitions[slug]['scheme'] = data['name']
  else
    # Needed for repos like stepchowfun/base16-circus-scheme, which has
    # "circus.yaml" (a scheme) and "toast.yml" (not a scheme).
    puts "Skipped: #{slug} (not a Base16 scheme definition)"
  end
end

banner "Updating template definitions"

templates = vendor.join("base16-templates")

# Here we only care about a subset of templates.
["kitty", "nvim", "shell", "tmux", "vim"].each do |target|
  if templates_list.has_key?(target)
    url = templates_list[target]
    template_author_and_repo = url.
      sub(%r{\Ahttps://github\.com/}, '').
      sub(%r{\.git\z}, '')
    template_dir = templates.join("base16-#{target}")
    template_dir_relative = template_dir.relative_path_from(Dir.pwd)
    unless ENV['NO_CLONE'] == '1'
      if template_dir.exist?
        puts "#{target}: updating clone #{template_dir_relative}"
        system("git", "-C", template_dir_relative.to_s, "pull")
      else
        puts "#{target}: cloning into #{template_dir_relative}"
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
  "kitty" => root.join("aspects/dotfiles/files/.config/kitty/colors"),
  "nvim" => root.join("aspects/nvim/files/.config/nvim/pack/bundle/opt/base16-nvim/colors"),
  "shell" => root.join("aspects/dotfiles/files/.zsh/colors"),
  "tmux" => root.join("aspects/dotfiles/files/.config/tmux/colors"),
  "vim" => root.join("aspects/nvim/files/.vim/colors"),
}.each do |target, output_dir|
  puts "Reading: base16-#{target} config"
  template_dir = templates.join("base16-#{target}")
  template_config = YAML.load(template_dir.join("templates/config.yaml").read)

  template_config.keys.each do |name|
    raise 'Missing "extension" key' unless template_config[name].has_key?("extension")
    extension = template_config[name]["extension"]
    if template_config[name]['supported-systems']&.include?('base24')
      # Beware base16-tmux, which has a Base24 template and uses interpolations
      # we don't currently support.
      puts "Skipping Base24 template: #{name}"
      next
    end
    source = template_dir.join("templates/#{name}.mustache")
    template = source.read
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
                      slug.to_s
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
                    when /\A[a-z0-f-]+\z/
                      # See https://github.com/chriskempson/base16/blob/main/builder.md
                      # for more possibilities, which I'll implement only if
                      # needed.
                      raise "error: unrecognized interpolation (#{interpolation.inspect}) in #{source}"
                    else
                      # Not a Base16 interpolation. Pass through. An
                      # example of this can be found in base16-tmux,
                      # which has a window status format containing
                      # `#W#{{?window_zoomed_flag,*Z,}}`.
                      interpolation
                    end
        end
      end
      output_file = output_dir.join("base16-#{slug}#{extension}")
      output_file_relative = output_file.relative_path_from(Dir.pwd)
      if output_file.exist?
        current_contents = output_file.read
        if output != current_contents
          puts "Writing: #{output_file_relative}"
          output_file.write(output)
        else
          puts "Up-to-date: #{output_file_relative}"
        end
      else
        puts "Creating: #{output_file_relative}"
        output_file.write(output)
      end
    end
  end
end
