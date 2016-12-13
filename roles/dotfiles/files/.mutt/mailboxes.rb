#!/usr/bin/env ruby

PRIORITY = {
  'Home' => '00',
  'Home.Starred' => '01',
  'Home.Sent' => '02',
  'Home.Drafts' => '03',
  'Home.Archive' => '04',
  'Home.Trash' => '05',
  'Home.Spam' => '06',
  'Work' => '00',
  'Work.Sent' => '02',
  'Work.Drafts' => '03',
  'Work.Archive' => '04',
  'Work.Trash' => '05',
  'Work.Spam' => '06',
}

mailboxes = []
Dir.chdir(ENV['HOME'] + '/.mail') do
  Dir['{Home,Work}/*'].each do |d|
    mailboxes << %{"+#{d}"}
  end
end
mailboxes.sort! do |a, b|
  account_a, mailbox_a = a.split('.')
  account_b, mailbox_b = b.split('.')
  key_a = account_a + PRIORITY.fetch(mailbox_a || account_a, '99') + mailbox_a.to_s
  key_b = account_b + PRIORITY.fetch(mailbox_b || account_b, '99') + mailbox_b.to_s
  key_a <=> key_b
end

File.open(ENV['HOME'] + '/.mutt/config/mailboxes.mutt', 'w') do |f|
  f.puts "mailboxes #{mailboxes.join(' ')}"
end
