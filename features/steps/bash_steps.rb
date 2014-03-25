require 'rubygems'
require 'fileutils'

Before do
      @aruba_timeout_seconds = 10
end

Given /^I'm in "([^\"]*)"$/ do |dir|
  FileUtils.cd(dir)
end

Given /^I am running GitFlow(?: .*?)? commands$/ do
    FileUtils.cd '/tmp'
    FileUtils.rm_rf 'TestRepo'
    FileUtils.mkdir 'TestRepo'
    FileUtils.cd 'TestRepo'
end
