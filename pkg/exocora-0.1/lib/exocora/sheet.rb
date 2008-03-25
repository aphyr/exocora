module Exocora
  # A single CGI script. Requests are processed through a chain of actions
  #
  # sanitize - extract and sanitize data from the CGI request
  # process  - do stuff
  # render   - render to the specified template.
  class Sheet
    def initialize
      @template = self.class.to_s.underscore
      @headers = "Content-type: text/html"
    end

    # Creates an instance of this sheet, and runs it.
    def self.run
      new.run
    end

    # Sends output to the client. The first time output is called, it sends an
    # HTTP header first.
    def output(string)
      unless @headers_sent
        puts @headers + "\n\n"
        @headers_sent = true
      end

      puts string
    end

    # Process is the meat of the script, which takes the clean data from
    # #sanitize. It returns a hash like {:a => 2}, which become instance
    # variables @a = 2 in the template.
    def process(data)
    end

    # Renders the erubis template for this action. Takes a hash of variables to
    # render. The default template is determined by underscoring this sheet's
    # class name, but another template can be specified using #template.
    def render(variables = {})
      # Read template data
      template_filename = "#{@template}.rhtml"
      begin
        template = File.read(template_filename)
      rescue Errno::ENOENT
        raise ScriptError.new("Template #{template_filename} does not exist!")
      end

      # Prepare template and variables
      template = Erubis::Eruby.new template
      binding = Support.bind variables
      
      # Perform templating
      begin
        result = template.result(binding)
      rescue NameError => e
        variable = e.message[/`[^']+'/]
        raise TemplateError.new("Undefined variable #{variable} referenced in template #{template_filename}")
      end

      # Output result
      output result 
    end

    # This is the action which initiates processing of the script.
    def run
      begin
        render(process(sanitize(CGI.new)))
      rescue
        output "#{$!.class}: #{$!}\n\n"
        output $!.backtrace.join("\n")
      end
    end

    # Sanitize takes a CGI request object as its single parameter. It returns a
    # hash of sanitized data, which is passed to the process method.
    def sanitize(cgi)
    end

    # Sets the name of the template to render.
    def template(template)
      @template = template
    end
  end
end
