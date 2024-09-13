#!/usr/bin/env ruby

require 'date'

# 2017-10-31: Personal MacBook Pro (Haswell, Mid-2015, dual graphics).
# → http://www.everymac.com/systems/apple/macbook_pro/specs/macbook-pro-core-i7-2.8-15-dual-graphics-mid-2015-retina-display-specs.html
#
# 2023-11-22: Personal MacBook Pro ("M3 Max" 16 CPU/40 GPU 16" (2023)).
# → https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-m3-max-16-core-cpu-40-core-gpu-16-late-2023-specs.html
#
# 2024-06-03: Datadog MacBook Pro ("M3 Max" 14 CPU/30 GPU 14" (2023)).
# → https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-m3-max-14-core-cpu-30-core-gpu-14-late-2023-specs.html

year = (ARGV[0] || 2023).to_i
month = (ARGV[1] || 11).to_i
day = (ARGV[2] || 22).to_i
diff = Date.today - Date.new(year, month, day)
puts "Days to date: #{diff.to_i}"
print 'How many failures so far? '
failures = STDIN.gets.to_i
puts 'Mean time between failures: %.2f' % (diff / failures)
