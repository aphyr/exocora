#!/usr/bin/ruby

require 'rubygems'
require 'exocora'

class HelloWorld < Exocora::Script
  def process(data)
    {:body => "Hello, world"}
  end
end

HelloWorld.run
