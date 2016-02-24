#!/usr/bin/env ruby

# copy 20000 byte, then change one byte, then copy the rest.

if (buf = $stdin.read(20000))
  $stdout.write buf
  if c = $stdin.getbyte
    $stdout.putc(c ^ 3)
    while buf = $stdin.read(2 ** 16)
      $stdout.write buf
    end
  end
end
