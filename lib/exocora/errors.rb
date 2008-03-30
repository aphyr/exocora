class Exception
  def to_html
    "<p><b>#{self.class}</b>: #{Erubis::XmlHelper::escape_xml(to_s)}</p>" +
    "<p>Backtrace:" +
    '<ul>' + backtrace.map { |line| 
      '<li><code>' + Erubis::XmlHelper::escape_xml(line) + '</code></li>'
    }.join + '</ul></p>'
  end
end

module Exocora
  # An error encountered when validating data
  class ValidationError < RuntimeError
    attr_accessor :value, :message
    def initialize(value, message = 'is invalid')
      @value = value
      @message = message
    end

    def to_s
      @message
    end
  end

  # Represents an error encountered in an Exocora sheet.
  class SheetError < RuntimeError
  end

  # Represents an error encountered when processing a template.
  class TemplateError < RuntimeError
    attr_accessor :message, :original
    def initialize(message, original)
      @message = message
      @original = original
    end

    def to_html
      "<p>" + Erubis::XmlHelper::escape_xml(@message) + "</p>" +
      "<p>The original exception was:</p>" +
      @original.to_html
    end
  end
end
