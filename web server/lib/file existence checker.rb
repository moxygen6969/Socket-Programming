#!/usr/bin/env ruby

if File.exist?("index.html")
  puts "Index file exists"
else
  puts "index either doesn't exist, you have the wrong path or directory"
end

pause_prog=gets.chomp