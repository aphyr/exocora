#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../lib/exocora'
#require '/home/aphyr/exocora/lib/exocora'

class HelloWorld < Exocora::Sheet
  def process
    {:body => "Hello, world"}
  end
end

HelloWorld.run
