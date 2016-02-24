#!/usr/bin/env ruby

oldnice = Process.getpriority(Process::PRIO_PROCESS,0)

# Set prio to "19",
# meaning, "run me only if nothing else wants to run".
Process.setpriority(Process::PRIO_PROCESS,0,19)


newnice = Process.getpriority(Process::PRIO_PROCESS,0)
$stderr.puts "Nice value increased from #{oldnice} to #{newnice}."

# Now same as we had:

load 'many_forks_flat.rb'
