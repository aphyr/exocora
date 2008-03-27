#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../lib/exocora'
#require '/home/aphyr/exocora/lib/exocora'

class Request < Exocora::Sheet
  def process
    {:r => request}
  end
end

Request.run
