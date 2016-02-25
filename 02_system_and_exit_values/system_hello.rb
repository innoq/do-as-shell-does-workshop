#!/usr/bin/env ruby

$stderr.puts "#{Process::pid} calls ./hello.rb."

system('./hello.rb')

$stderr.puts "Back in #{Process::pid}."



