#!/usr/bin/env ruby

child_pid = nil

File.open "write_conflict_lowlevel.out", "w" do |file|
  file.syswrite "I'm the parent, #{Process.pid}.\n"
  child_pid = fork
  if child_pid.nil?
    file.syswrite "I'm the child, #{Process.pid}.\n"
  else
    Process::wait(child_pid)
    if $?.success?
      file.syswrite "Child ok.\n"
    else
      file.syswrite "Child unhappy."
    end
  end
end

