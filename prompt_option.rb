#!/usr/bin/env ruby
ROOT = '/'
GIT_DIR = '.git'
HG_DIR = '.hg'

cur = Dir.pwd
branch = nil

begin
  if File.directory?("#{cur}/.git")
    if `git branch` =~ /\* (\S*)/
      branch = "(git: #{$1})"
    else
      branch = '(git)'
    end
    break
  elsif File.directory?("#{cur}/.hg")
    `hg branch` =~ /(\S*)/
    branch = $1 ? "(hg: #{$1})" : '(hg)'
    break
  end
  
  # goto parent dirctory
  cur = File.dirname(cur)
end while cur != ROOT

puts branch
