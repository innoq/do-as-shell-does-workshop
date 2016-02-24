#!/usr/bin/env ruby

File.open "write_conflict.out", "w" do |file|
  file.puts "I'm the parent, #{Process.pid}."
  child_pid = fork
  if child_pid.nil?
    file.puts "I'm the child, #{Process.pid}."
  else
    Process::wait(child_pid)
    if $?.success?
      file.puts "Child ok."
    else
      file.puts "Child unhappy."
    end
  end
end

