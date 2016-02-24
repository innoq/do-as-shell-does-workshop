#!/usr/bin/env ruby

puts "First call from process #{Process::pid}"

system 'ps', 'f', 'T'

puts "\nSecond call from process #{Process::pid}"

system "ps f T"

puts "\nThird call from process #{Process::pid}"

system "ps f 'T'"
