#!/usr/bin/env ruby

File.open "write.out", "w" do |file|
  file.puts "I am process #{Process::pid}."
end
