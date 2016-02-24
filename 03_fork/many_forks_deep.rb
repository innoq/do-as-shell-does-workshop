#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

wanted_fork_count = 15

while 0 < wanted_fork_count
  child_pid = fork
  if child_pid.nil?
    # I'm the child
    wanted_fork_count -= 1
    if 0 == wanted_fork_count
      system 'ps', 'f', 'T' or raise "Couldn't system"
    end
  else
    # I'm the parent

    # My children will work for me:
    wanted_fork_count = 0

    # Just wait for the child to be done:
    Process::wait child_pid
  end
end
