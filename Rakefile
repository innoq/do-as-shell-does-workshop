

@sections = Dir.glob('0?_*.md').sort.map{|s| s.sub(/(.+)\.md/,'\1')}

default = task :default => [ :index, :logo ] do
  $stderr.puts "done"
end

task :logo do
  FileUtils.mkdir_p 'jekyll/about/images'
  FileUtils.cp 'images/CC_logo_88x31.png', 'jekyll/about/images'
end

# task :stuff_dir do
#   FileUtils.mkdir_p 'jekyll/_includes/stuff'
# end

task :index do
  $stderr.puts "Doing task :index."
  File.open "jekyll/index.md", 'w' do |outf|

    outf.write "---
title: Main page
layout: default
---
"
    
    outf.write "## Workshop material\n\n"
    
    @sections.each  do |s|
      if s =~ /\A\d\d\_(.+)\Z/
        title = $1
        outf.write "* [#{title}](#{s}.html)\n"
      else
        raise "Unexpected section #{s}"
      end
    end    
  end
end

@sections.each_index do |i|
  s = @sections[i]
  next_s = (i+1 < @sections.length ? "#{@sections[i+1]}.html" : nil)
  previous_s = (0 <= i-1 ? "#{@sections[i-1]}.html" : nil)
  # task "#{s}_dir".to_sym => :stuff_dir do
  #   targetdir = "jekyll/_includes/stuff/#{s}"
  #   FileUtils.mkdir_p targetdir
  #   Dir.glob("#{s}/*.rb") do |rbfile|
  #     FileUtils.cp rbfile, targetdir
  #   end
  # end
  task s.to_sym do
    $stderr.puts "Doing task #{s}."
    File.open("jekyll/#{s}.md", 'w') do |outf|
      title = $1 if s =~ /\A\d\d\_(.+)\Z/
      outf.write "---\n"
      outf.write "title: #{title}\n"
      outf.write "layout: section\n"
      outf.write "previous_section: #{previous_s}\n" if previous_s
      outf.write "next_section: #{next_s}\n" if next_s
      outf.write "---\n"
      File.open("#{s}.md", 'r') do |inf|
        inf.each_line do |line|
          if line =~ /\Ayyi\s+([^\s]+)\s*\Z/ \
            or line =~ /\Ayyinoout\s+([^\s]+)\s*\Z/
            rubyfile_basename = $1
            outf.write "File `#{s}/#{rubyfile_basename}.rb`:\n\n"
            outf.write "{% highlight ruby %}\n"
            File.open "#{s}/#{rubyfile_basename}.rb" do |rf|
              rf.each_line do |l|
                outf.write l
              end
            end
            outf.write "{% endhighlight %}\n"
            unless line =~ /\Ayyinoout/
              r,w = IO.pipe
              child_pid = fork
              if child_pid.nil?
                r.close
                Dir.chdir s
                $stdout.reopen(w)
                w.close
                $stderr.reopen($stdout)
                exec "./#{rubyfile_basename}.rb"
                raise "Could not exec"
              end
              w.close
              outf.write "Output is:\n\n```\n"
              while(buf = r.read(2 ** 16))
                outf.write(buf)
              end
              outf.write "\n```\n\n"
              Process.wait child_pid
              if $?.success?
                outf.write "Programm ran successfully.\n\n"
              elsif $?.exitstatus
                outf.write "Programm **failed** with status #{$?.exitstatus}.\n\n"
              elsif $?.signaled?
                outf.write "Programm **terminated via signal** #{Signal.signame $?.termsig}\n\n"
              else
                raise "Ooops - #{$?.inspect}"
              end
            end
          else
            outf.write line
          end
        end
      end
    end
  end
  default.enhance([s.to_sym])
end




