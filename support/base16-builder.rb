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

def banner(msg)
  width = IO.console.winsize[1]
  puts
  puts "#" * width
  puts "# " + msg + " " * [0, width - msg.length - 4].max + " #"
  puts "#" * width
  puts
end

def relative(path)
  path.relative_path_from(Dir.pwd)
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
  slug = scheme_definition.basename.sub_ext("").to_s
  data = YAML.load_file(scheme_definition)
  if data["system"] == "base16"
    puts "Read: #{slug}"
    scheme_definitions[slug] = data['palette']
    scheme_definitions[slug]['author'] = obliterate_crypto_casino_links(data['author'])
    scheme_definitions[slug]['scheme'] = data['name']
    scheme_definitions[slug]['system'] = data['system']
  else
    puts "Skipped: #{slug} (not a Base16 scheme definition)"
  end
end

templates = vendor.join("base16-templates")

banner "Updating templates"

# Tuple of [template source, output base directory].
[
  [
    root.join('vendor/tinted-theming/base16-vim'),
    root.join("aspects/nvim/files/.vim"),
  ],
  [
    root.join('vendor/tinted-theming/tinted-kitty'),
    root.join("aspects/dotfiles/files/.config/kitty"),
  ],
  [
    root.join('vendor/tinted-theming/tinted-shell'),
    root.join("aspects/dotfiles/files/.zsh/colors"),
  ],
  [
    root.join('vendor/tinted-theming/tinted-tmux'),
    root.join("aspects/dotfiles/files/.config/tmux"),
  ],
  [
    root.join('aspects/nvim/files/.config/nvim/pack/bundle/opt/base16-nvim'),
    root.join("aspects/nvim/files/.config/nvim/pack/bundle/opt/base16-nvim"),
  ],
].each do |(source, output_base)|
  template_config_path = source.join("templates/config.yaml")
  template_config = YAML.load_file(template_config_path)
  puts "Read: #{relative(template_config_path)} config"

  template_config.keys.each do |name|
    raise 'Missing "extension" key' unless template_config[name].has_key?("extension")
    output_dir = template_config[name]["output"]
    extension = template_config[name]["extension"]
    if template_config[name]['supported-systems']&.include?('base24')
      puts "Skipping Base24 template: #{name}"
      next
    end
    source_file = source.join("templates/#{name}.mustache")
    template = source_file.read
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
                    when /\A\s*scheme-system\s*\z/
                      definition["system"]
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
                      raise "error: unrecognized interpolation (#{interpolation.inspect}) in #{relative(source_file)}"
                    else
                      # Not a Base16 interpolation. Pass through. An
                      # example of this can be found in tmux-tinted,
                      # which has a window status format containing
                      # `#W#{{?window_zoomed_flag,*Z,}}`.
                      interpolation
                    end
        end
      end
      output_file = output_base.join(output_dir, "base16-#{slug}#{extension}")
      output_file_relative = relative(output_file)
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
