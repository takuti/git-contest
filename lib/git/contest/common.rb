#
# common.rb
#
# Copyright (c) 2013 Hiroyuki Sano <sh19910711 at gmail.com>
# Licensed under the MIT-License.
#

require 'git/contest/version'
require 'git/contest/test'
require 'git/contest/git'
require 'contest/driver'
require 'yaml'

def init
  init_global
  init_home
end

def init_global
  $git_contest_home   = File.expand_path(ENV['GIT_CONTEST_HOME'] || "~/.git-contest")
  $git_contest_config = File.expand_path(ENV['GIT_CONTEST_CONFIG'] || "#{$git_contest_home}/config.yml")
  if git_do_no_echo 'branch'
    $MASTER = git_do 'config --get git.contest.branch.master'
    $PREFIX = git_do 'config --get git.contest.branch.prefix'
    $ORIGIN = git_do 'config --get git.contest.origin'
    if $ORIGIN == ''
      $ORIGIN = 'origin'
    end
    $GIT_CONTEST_GIT_OK = true
  else
    $GIT_CONTEST_GIT_OK = false
  end
end

def init_home
  if ! FileTest.exists? $git_contest_home
    FileUtils.mkdir $git_contest_home
  end
  if ! FileTest.exists? $git_contest_config
    FileUtils.touch $git_contest_config
  end
end

def get_config
  config_path = File.expand_path($git_contest_config)
  YAML.load_file config_path
end

