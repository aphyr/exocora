#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../lib/exocora'

class HelloWorld < Exocora::Sheet
  def process(data)
    {:body => "Hello, world"}
  end
end

HelloWorld.run
