#!/usr/bin/env ruby

PRIORITY = {
  '"+INBOX"' => '00',
  '"+Starred"' => '01',
  '"+Sent"' => '02',
  '"+Drafts"' => '03',
  '"+Archive"' => '04',
  '"+Trash"' => '05',
  '"+Spam"' => '06',
  '"+Search"' => '99',
}

mailboxes = Dir.chdir(ENV['HOME'] + '/.mail') do
  Dir['*'].map do |d|
    %{"+#{d}"}
  end
end
mailboxes.sort! do |a, b|
  key_a = PRIORITY.fetch(a, '50') + a.to_s
  key_b = PRIORITY.fetch(b, '50') + b.to_s
  key_a <=> key_b
end

File.open(ENV['HOME'] + '/.mutt/config/mailboxes.mutt', 'w') do |f|
  f.puts "mailboxes #{mailboxes.join(' ')}"
end
