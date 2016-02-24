#!/usr/bin/env ruby

children_pids = []

wanted_fork_count = 10000

# On my laptop, one fork takes a little less than 1 ms,
# when this script does a lot of them.
# Sleep long enough so the firstly-created processes
# are still likely to sleep while the last process is created.
sleep_time = 1 + wanted_fork_count * 0.0015
$stderr.puts "Sleep time is #{sleep_time} s."
# (Strictly speaking, this is a race condition.)

while 2 <= wanted_fork_count
  child_pid = fork
  if child_pid.nil?
    if 2 == wanted_fork_count
      # Of the 2 processes,
      # one is the new child executing this,
      # the other one is this:
      system 'ps', 'f', 'T' or raise "Couldn't ps"
    else
      sleep sleep_time
    end
    # Mental exercise:
    # What happens when you forget the following line?
    exit 0
  else
    # I'm the parent
    # Remember the child pid,
    # to collect the exit status later:
    children_pids << child_pid
    # One fork less I still need to do:
    wanted_fork_count -= 1
  end
end

all_well = true

children_pids.each do |child_pid|
  Process::wait child_pid
  if not $?.success?
    $stderr.puts "#{$?.pid} unhappy, exit status {$?.exitstatus}"
    all_well = false
  end
end

raise "Problem with at least one child." unless all_well
