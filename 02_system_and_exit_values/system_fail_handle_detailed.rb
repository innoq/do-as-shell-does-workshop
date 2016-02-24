#!/usr/bin/env ruby

$stderr.puts "About to call, says upper #{Process::pid}."

system('./fail_via_exit.rb')

$stderr.puts "Done calling, $? is now \"#{$?.inspect}\", says upper #{Process::pid}."

# See http://ruby-doc.org/core-2.2.3/Process/Status.html ...

if $?.success?
  $stderr.puts "Down #{$?.pid} was happy, exit status is (of course) #{$?.exitstatus}."
elsif $?.signaled?
  $stderr.puts "Down #{$?.pid} received signal \"#{$?.termsig}\"."
else
  $stderr.puts "Down #{$?.pid} has exit status #{$?.exitstatus}."
end



