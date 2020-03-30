#!/usr/bin/env ruby

require 'date'

# 2017-10-31: Personal MacBook Pro (Haswell, Mid-2015, dual graphics).
# 2019-01-14: Liferay MacBook Pro 15-Inch "Core i7" 2.6 Touch/2018

year = (ARGV[0] || 2017).to_i
month = (ARGV[1] || 10).to_i
day = (ARGV[2] || 31).to_i
diff = Date.today - Date.new(year, month, day)
puts "Days to date: #{diff.to_i}"
print 'How many failures so far? '
failures = gets.to_i
puts 'Mean time between failures: %.2f' % (diff / failures)
