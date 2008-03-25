module Exocora
  class Sheet

    # A single CGI script. Requests are processed through a chain of actions
    #
    # sanitize - extract and sanitize data from the CGI request
    # process  - do stuff
    # render   - render to the specified template.

    def initialize
      @template = self.class.to_s.downcase
    end

    def self.run
      new.run
    end

    # Renders the specified erubis template. Takes a hash of variables to rende
    def render(variables = {})
      template_filename = "templates/#{@template}.rhtml"
      begin
        template = File.read(template_filename)
      rescue Errno::ENOENT
        raise ScriptError.new("Template #{template_filename} does not exist!")
      end

      template = Erubis::Eruby.new template
      binding = Support.bind variables
      
      begin
        result = template.result(binding)
      rescue NameError => e
        variable = e.message[/`[^']+'/]
        raise TemplateError.new("Undefined variable #{variable} referenced in template #{template_filename}")
      end

      puts "Content-type: text/html\n\n"
      puts result
    end

    # This is the action which initiates processing of the script.
    def run
      begin
        render(process(sanitize(CGI.new)))
      rescue
        puts "Content-type: text/plain\n\n"
        puts "#{$!.class}: #{$!}\n\n"
        puts $!.backtrace.join("\n")
      end
    end

    # Sanitize takes a CGI request object as its single parameter. It returns a
    # hash of sanitized data, which is passed to the process method.
    def sanitize(cgi)
    end

    # Process is the meat of the script, which takes the clean data from
    # #sanitize. It returns a hash like {:a => 2}, which become instance
    # variables @a = 2 in the template.
    def process(data)
    end

    # Sets the name of the template to render.
    def template(template)
      @template = template
    end
  end
end
