#!/usr/bin/env ruby

require 'date'

# 2014-01-21: First Facebook MacBook Air (Mid-2013).
# 2015-06-02: Second Facebook MacBook Air (Mid-2013) (replacement for busted port).
# 2015-11-16: Facebook MacBook Pro (Haswell, Mid-2015, integrated graphics).
# 2016-07-19: Facebook MacBook Pro (Haswell, Mid-2015, dual graphics) (replacement because previous one was black-screening and other odd stuff).
# 2017-10-31: Personal MacBook Pro (Haswell, Mid-2015, dual graphics).
# 2019-01-14: Liferay MacBook Pro

year = (ARGV[0] || 2017).to_i
month = (ARGV[1] || 10).to_i
day = (ARGV[2] || 31).to_i
diff = Date.today - Date.new(year, month, day)
puts "Days to date: #{diff.to_i}"
print 'How many failures so far? '
failures = gets.to_i
puts 'Mean time between failures: %.2f' % (diff / failures)
