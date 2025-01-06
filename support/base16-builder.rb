#!/usr/bin/env ruby

require "fileutils"
require "io/console"
require "pathname"
require "strscan"
require "yaml"

base = Pathname.new(__dir__)
root = base.join("..")
vendor = root.join("vendor")
schemes =
  vendor.join("tinted-theming/schemes/base16").glob("*.yaml") +
  vendor.join("tinted-theming/schemes/base24").glob("*.yaml")

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

banner "Updating schema definitions"

scheme_definitions= {}

schemes.each do |scheme_definition|
  slug = scheme_definition.basename.sub_ext("").to_s
  data = YAML.load_file(scheme_definition)
  if data["system"] == "base16" || data["system"] == "base24"
    # Note that because we read base24 schemes after base16 ones, the base24
    # values overwrite and take precedence over the base16 ones.
    puts "Read: #{slug}"
    scheme_definitions[slug] = data['palette'].transform_values do |v|
      # Hack to accommodate https://github.com/tinted-theming/schemes/pull/34
      # which added a `#` prefix to all the values.
      if v.start_with?("#")
        v[1..-1]
      else
        v
      end
    end
    if data["system"] == "base16"
      # Set up fallback values for base24 colors in base16 themes:
      # https://github.com/tinted-theming/base24/blob/main/styling.md
      scheme_definitions[slug]['base10'] = scheme_definitions[slug]['base00']
      scheme_definitions[slug]['base11'] = scheme_definitions[slug]['base00']
      scheme_definitions[slug]['base12'] = scheme_definitions[slug]['base08']
      scheme_definitions[slug]['base13'] = scheme_definitions[slug]['base0A']
      scheme_definitions[slug]['base14'] = scheme_definitions[slug]['base0B']
      scheme_definitions[slug]['base15'] = scheme_definitions[slug]['base0C']
      scheme_definitions[slug]['base16'] = scheme_definitions[slug]['base0D']
      scheme_definitions[slug]['base17'] = scheme_definitions[slug]['base0E']
    end
    scheme_definitions[slug]['author'] = obliterate_crypto_casino_links(data['author'])
    scheme_definitions[slug]['description'] = data.fetch(
      'description',
      '(no description provided)'
    )
    scheme_definitions[slug]['scheme'] = data['name']
    scheme_definitions[slug]['system'] = data['system']
  else
    puts "Skipped: #{slug} (not a Base16/Base24 scheme definition)"
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

  # As of 2024-12-31, some templates have forms like this:
  #
  #     # tinted-theming/tinted-vim:
  #     tinted-vim:
  #       supported-systems: [base24, base16]
  #       filename: colors/{{ scheme-system }}-{{ scheme-slug }}.vim
  #
  #     # tinted-theming/tinted-kitty:
  #     base16:
  #       filename: colors/ {{ scheme-system }}-{{ scheme-slug }}.conf
  #       supported-systems: [base16]
  #     base24:
  #       filename: colors/ {{ scheme-system }}-{{ scheme-slug }}.conf
  #       supported-systems: [base24]
  #
  # While others have this form:
  #
  #     # tinted-theming/tinted-shell:
  #     base16:
  #       extension: .sh
  #       output: scripts
  #     base24:
  #       extension: .sh
  #       output: scripts
  #       supported-systems: [base24]
  #
  #     # tinted-theming/tinted-tmux:
  #     base16:
  #       extension: .conf
  #       output: colors
  #     base24:
  #       extension: .conf
  #       output: colors
  #       supported-systems: [base24]

  template_config.keys.each do |name|
    if name.end_with?("-deprecated")
      puts "Skipping deprecated template: #{name}"
      next
    end
    if !template_config[name]['supported-systems']&.include?('base24')
      puts "Skipping non-Base24 template: #{name}"
      next
    end
    output_dir = ''
    extension = ''
    if template_config[name].has_key?("filename")
      filename = Pathname.new(template_config[name]["filename"])
      output_dir = filename.each_filename.first # first path component
      extension = filename.extname
    elsif template_config[name].has_key?("extension") &&
      template_config[name].has_key?("output")
      output_dir = template_config[name]["output"]
      extension = template_config[name]["extension"]
    else
      raise 'Template must have "extension"/"output" keys or a "filename" key'
    end
    source_file = source.join("templates/#{name}.mustache")
    template = source_file.read
    template = obliterate_crypto_casino_links(template)
    scheme_definitions.each do |slug, definition|
      lookup = ->(value) {
        result =  case value
                  when /\A\s*scheme-author\s*\z/
                    definition["author"]
                  when /\A\s*scheme-description\s*\z/
                    definition["description"]
                  when /\A\s*scheme-name\s*\z/
                    definition["scheme"]
                  when /\A\s*scheme-slug\s*\z/
                    slug
                  when /\A\s*scheme-system\s*\z/
                    definition["system"]
                  when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F|10|11|12|13|14|15|16|17)-dec-([rgb])\s*\z/
                    case $~[2]
                    when "r" then (definition["base#{$~[1]}"][0..1].to_i(16) / 255.0).to_s
                    when "g" then (definition["base#{$~[1]}"][2..3].to_i(16) / 255.0).to_s
                    when "b" then (definition["base#{$~[1]}"][4..5].to_i(16) / 255.0).to_s
                    end
                  when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F|10|11|12|13|14|15|16|17)-hex\s*\z/
                    definition["base#{$~[1]}"]
                  when /\A\s*base(00|01|02|03|04|05|06|07|08|09|0A|0B|0C|0D|0E|0F|10|11|12|13|14|15|16|17)-hex-([rgb])\s*\z/
                    case $~[2]
                    when "r" then definition["base#{$~[1]}"][0..1].to_s
                    when "g" then definition["base#{$~[1]}"][2..3].to_s
                    when "b" then definition["base#{$~[1]}"][4..5].to_s
                    end
                  else
                    raise "error: failed look-up (#{value.inspect}) in #{relative(source_file)}"
                  end
        if result.nil?
          ""
        else
          result
        end
      }
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
                    when /\A#[a-z0-f-]+\z/
                      # Non-empty lists; eg: render "value" if "foo" is set:
                      #   {{#foo}value{{/foo}}
                      # See: https://mustache.github.io/mustache.5.html
                      interpolation = interpolation[1..]
                      end_marker = "{{/#{interpolation}}}"
                      peeked = scanner.scan_until(Regexp.new(Regexp.escape(end_marker)))
                      if peeked.nil?
                        raise "Failed to find end marker: #{end_marker}"
                      elsif lookup.call(interpolation)
                        if peeked.start_with?('{{') && peeked.end_with?('}}')
                          # Hack: not fully recursing, but good enough for now.
                          lookup.call(peeked[2...-(end_marker.length + 2)])
                        else
                          peeked[0...-end_marker.length]
                        end
                      else
                        ""
                      end
                    when /\A\^[a-z0-f-]+\z/
                      # Inverted sections; eg: render "fallback" if "foo" not set:
                      #   {{^foo}fallback{{/foo}}
                      # See: https://mustache.github.io/mustache.5.html
                      interpolation = interpolation[1..]
                      end_marker = "{{/#{interpolation}}}"
                      peeked = scanner.scan_until(Regexp.new(Regexp.escape(end_marker)))
                      if peeked.nil?
                        raise "Failed to find end marker: #{end_marker}"
                      elsif lookup.call(interpolation)
                        ""
                      else
                        if peeked.start_with?('{{') && peeked.end_with?('}}')
                          # Hack: not fully recursing, but good enough for now.
                          lookup.call(peeked[2...-(end_marker.length + 2)])
                        else
                          peeked[0...-end_marker.length]
                        end
                      end
                    else
                      lookup.call(interpolation)
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
