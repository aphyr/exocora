#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../lib/exocora'
#require '/home/aphyr/exocora/lib/exocora'

class Validation < Exocora::Sheet

  validate(:short) do |value|
    value.length < 4
  end

  validate(:num, "must be a number").when Numeric
  validate(:empty).unless(lambda { |s| s.size > 0 }).note("must be empty")

  def process
    {:params => params, :errors => errors}
  end
end

Validation.run
