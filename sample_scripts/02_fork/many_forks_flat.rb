#!/usr/bin/env ruby

puts "I'm #{Process::pid}."

wanted_fork_count = 15

children_pids = []

  child_pid = fork
  if child_pid.nil?
    if 1 == wanted_fork_count
      system 'ps', 'f', 'T' or raise "Couldn't system"
    else
      sleep 3
    end
    exit 0
  else
    # I'm the parent
    wanted_fork_count -= 1
    children_pids << child_pid
  end
end

children_pids.each do |child_pid|
  Process::wait child_pid
end
