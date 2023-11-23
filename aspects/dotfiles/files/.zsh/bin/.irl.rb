#!/usr/bin/env ruby

require 'date'

# 2017-10-31: Personal MacBook Pro (Haswell, Mid-2015, dual graphics).
# 2021-05-31: GitHub MacBook Pro (13-Inch "M1" 8-Core 3.2 (2020)).
# 2023-11-22: Personal MacBook Pro ("M3 Max" 16 CPU/40 GPU 16" (2023)).

year = (ARGV[0] || 2023).to_i
month = (ARGV[1] || 11).to_i
day = (ARGV[2] || 22).to_i
diff = Date.today - Date.new(year, month, day)
puts "Days to date: #{diff.to_i}"
print 'How many failures so far? '
failures = STDIN.gets.to_i
puts 'Mean time between failures: %.2f' % (diff / failures)
