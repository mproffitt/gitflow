require 'rubygems'
require 'fileutils'

Given /^I'm in "([^\"]*)"$/ do |dir|
  FileUtils.cd(dir)
end

Given(/^I am running GitFlow(?: .*?)? commands$/) do

end
