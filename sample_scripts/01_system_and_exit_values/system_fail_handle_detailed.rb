#!/usr/bin/env ruby

puts "About to call, says upper #{Process::pid}."

system('./fail_via_exit.rb')

puts "Done calling, $? is now \"#{$?.inspect}\", says upper #{Process::pid}."

# See http://ruby-doc.org/core-2.2.3/Process/Status.html ...

if $?.success?
  puts "Down #{$?.pid} was happy, exit status is (of course) #{$?.exitstatus}."
elsif $?.signaled?
  puts "Down #{$?.pid} received signal \"#{$?.termsig}\"."
else
  puts "Down #{$?.pid} has exit status #{$?.exitstatus}."
end



