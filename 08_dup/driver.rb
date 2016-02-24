#!/usr/bin/env ruby

cmds = ['./count_to_1m.rb',
        'gzip',
        './distort_after_20k.rb',
        'zcat',
        'wc']

# Put an extra pipe in front of cmds[0],
# even though not needed.
pipes = cmds.map {|i| IO.pipe}

child_pids = (0 .. cmds.length-1).map do |i|
  result = fork
  if result.nil?
    readMe = nil
    writeMe = nil
    cmds.each_index do |j|
      r,w = pipes[j]
      if j == i
        readMe = r
        w.close
      elsif j - 1 == i
        writeMe = w
        r.close
      else
        r.close
        w.close
      end
    end
    $stdin.reopen(readMe)
    $stdout.reopen(writeMe) if writeMe
    exec cmds[i]
  end
  result
end

pipes.each do |p|
  p[0].close
  p[1].close
end

mes = []

child_pids.each_index do |i|
  Process.wait child_pids[i]
  if not $?.success?
    mes << "ERROR: Process \"#{cmds[i]}\" had a problem," +
      " returned #{$?.exitstatus}."
  end
end

if 0 < mes.length
  raise mes.join("\n")
end
