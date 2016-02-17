#!/usr/bin/env ruby

puts "I'm #{Process::pid}."

wanted_process_count = 15

sleeptime = 0.2

wanted_process_count -= 1 # This main process we have already.

always_b = true

while 0 < wanted_process_count
  if 1 == wanted_process_count
    # Only want either the ps or the sleep.
    if always_b
      system 'ps', 'f', '-f', 'T' or raise "Couldn't ps"
    else
      # Abbreviation allowed in ruby:
      child_pid = fork { sleep sleeptime }
      # child runs code block, then exit(0).
      Process.wait child_pid
      raise "child didn't sleep well" unless $?.success?
    end
    wanted_process_count = 0
  elsif 2 == wanted_process_count
    if always_b
      child_pid = fork { system 'ps', 'f', 'T' or raise "Couldn't ps." }
      Process.wait child_pid
      raise "child that was to call ps not happy." unless $?.success?
    else
      child_a_pid = fork { sleep sleeptime }
      child_b_pid = fork { sleep sleeptime }
      Process.wait child_b_pid
      raise "Child b wasn't sleepy, #{$?.exitstatus}" unless $?.success?
      Process.wait child_a_pid
      raise "Child a wasn't sleepy, #{$?.exitstatus}" unless $?.success?
    end
    wanted_process_count = 0
  else
    wanted_process_count_a = wanted_process_count / 2
    wanted_process_count_b = wanted_process_count - wanted_process_count_a
    child_a_pid = fork
    if child_a_pid.nil?
      always_b = false
      wanted_process_count = wanted_process_count_a - 1
      sleep sleeptime if 0 == wanted_process_count
    else
      child_b_pid = fork
      if child_b_pid.nil?
        wanted_process_count = wanted_process_count_b - 1
        sleep sleeptime if 0 == wanted_process_count
      else
        wanted_process_count = 0
        Process.wait child_b_pid
        raise "Child b was unhappy, #{$?.exitstatus}" unless $?.success?
        Process.wait child_a_pid
        raise "Child a was unhappy, #{$?.exitstatus}" unless $?.success?
      end
    end
  end
end
