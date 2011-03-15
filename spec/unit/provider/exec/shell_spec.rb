#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../../spec_helper'

provider_class = Puppet::Type.type(:exec).provider(:shell)

describe provider_class do
  before :each do
    @resource = Puppet::Resource.new(:exec, 'foo')
    @provider = provider_class.new(@resource)
  end

  describe "#run" do
    it "should be able to run builtin shell commands" do
      output, status = @provider.run("echo foo")
      status.exitstatus.should == 0
      output.should == "foo\n"
    end

    it "should be able to run commands with single quotes in them" do
      output, status = @provider.run("echo 'foo bar'")
      status.exitstatus.should == 0
      output.should == "foo bar\n"
    end

    it "should be able to run commands with double quotes in them" do
      output, status = @provider.run("echo 'foo bar'")
      status.exitstatus.should == 0
      output.should == "foo bar\n"
    end

    it "should be able to read values from the environment parameter" do
      @resource[:environment] = "FOO=bar"
      output, status = @provider.run("echo $FOO")
      status.exitstatus.should == 0
      output.should == "bar\n"
    end
  end

  describe "#validatecmd" do
    it "should always return true because builtins don't need path or to be fully qualified" do
      @provider.validatecmd('whateverdoesntmatter').should == true
    end
  end
end
