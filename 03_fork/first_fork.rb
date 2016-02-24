#!/usr/bin/env ruby

$stderr.puts "I'm #{Process::pid}."

whatsthis = fork

$stderr.puts "I have #{whatsthis.inspect} and I'm #{Process::pid}."
