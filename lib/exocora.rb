require 'rubygems'
require 'cgi'
require 'erubis'

APPDIR = File.dirname(File.expand_path($0))
BASEDIR = File.dirname(File.expand_path(__FILE__))

$LOAD_PATH.unshift(BASEDIR)
$LOAD_PATH.uniq!

require 'exocora/sheet'
require 'exocora/support'
require 'exocora/errors'

module Exocora
end
