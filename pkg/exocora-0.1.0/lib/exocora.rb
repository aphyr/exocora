# Exocora is an obscure species of spider, in the sheet weaver family.
# 
# It is also a small web framework for writing CGI scripts, or "sheets". Each
# request has a three-stage lifecycle, in which it extracts and checks incoming
# data for safety, performs some operations, and renders a templated result.

require 'rubygems'
require 'cgi'
require 'erubis'

APPDIR = File.dirname(File.expand_path($0))
BASEDIR = File.dirname(File.expand_path(__FILE__))

$LOAD_PATH.unshift(BASEDIR)
$LOAD_PATH.uniq!

require 'string'
require 'array'
require 'cgi'
require 'exocora/support'
require 'exocora/errors'
require 'exocora/validation'
require 'exocora/sheet'

module Exocora
end
