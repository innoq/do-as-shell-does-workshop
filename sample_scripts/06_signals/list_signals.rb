#!/usr/bin/env ruby

Signal.list.each do |sig, num|
  puts "Signal #{num}: #{sig}."
end
