module Exocora
  # A single CGI script. Requests are processed through a chain of actions
  #
  # validate - extract and sanitize data from the CGI request
  # process  - do stuff
  # render   - render to the specified template.
  class Sheet
    # Parameters with validations
    @@validations = Hash.new

    attr_reader :params, :errors

    def initialize
      @cgi = CGI.new
      @headers = {
      }
      
      @params = {}
      @errors = {}
      
      @template = self.class.to_s.module_path
      @log_file = self.class.to_s.underscore + '.log'
    end

    # Add a validation to the validation stack
    def self.add_validation(param, validation)
      @@validations[param.to_sym] ||= []
      @@validations[param.to_sym] << validation
      validation
    end

    # Adds a validation condition for a parameter.
    # validate :query { |q| q.size > 0 }
    # validate :query, "is invalid" { |q| 
    def self.validate(param, message='must be valid', &block)
      validation = Validation.new(nil, message)
      if block_given?
        validation.when block
      end

      add_validation param, validation
    end

    # Ensure that a parameter is non-nil
    def self.validate_presence_of(param, *params)
      add_validation param, ValidationOfPresence.new(*params)
    end

    # Creates an instance of this sheet, and runs it.
    def self.run
      new.run
    end

    # Adds an error on a parameter
    def add_error(param, error)
      @errors[param] ||= []
      @errors[param] << error
    end

    # Casts incoming CGI parameters to nil, numerics, collapses single-element
    # arrays, and so forth.
    def cast_params(params)
      cast = {}
      params.each do |key, values|
        cast_values = values.map do |value|
          if value =~ /^\d+$/
            value.to_i
          elsif value =~ /^[\d.]+$/
            value.to_f
          else
            value
          end
        end

        # I prefer indexing by symbols
        key = key.to_sym

        # Store cast values
        if values.empty?
          cast[key] = nil
        elsif values.size == 1
          cast[key] = cast_values.first
        else
          cast[key] = cast_values
        end
      end

      cast
    end

    # Logs a message to a file.
    def log(message)
      File.open(@log_file, 'a') do |file|
        file.puts message
      end
    end

    # Chooses the file for logging.
    def log_to(file)
      @log_file = file
    end

    # Sends output to the client. The first time output is called, it sends an
    # HTTP header first.
    def output(string)
      unless @headers_sent
        puts @cgi.header(@headers)
        @headers_sent = true
      end

      puts string
    end

    # Process is the meat of the script.
    # It returns a hash like {:a => 2}, which become instance
    # variables @a = 2 in the template.
    def process
    end

    # Breaks the normal rendering flow, and outputs an HTTP redirect header.
    def redirect_to(uri_fragment = @cgi.uri, params = {})
      @headers['Status'] = '302 Moved'
      @headers['Location'] = url_for(@cgi.full_uri_for(uri_fragment), params)
      output
      exit
    end

    # Renders the erubis template for this action. Takes a hash of variables to
    # render. The default template is determined by underscoring this sheet's
    # class name, but another template can be specified using #template.
    def render(context = Erubis::Context.new)
      # Read template data
      template_filename = "#{@template}.rhtml"
      begin
        template = File.read(template_filename)
      rescue Errno::ENOENT
        raise ScriptError.new("Template #{template_filename} does not exist!")
      end

      # Prepare template and variables
      eruby = Erubis::Eruby.new template
      
      # Perform templating
      begin
        result = eruby.evaluate context
      rescue Exception => e
        if e.backtrace.first =~ /\(erubis\):(\d+)/
          message = "encountered error processing template #{template_filename} at line #{$1}"
        else
          message = "encountered error processing template #{template_filename}"
        end
        raise TemplateError.new(message, e)
      end

      # Output result
      output result 
    end

    # Accessor for the CGI object
    def request
      @cgi
    end

    # This is the action which initiates processing of the script.
    def run
      begin
        # Cast parameters
        @params = cast_params @cgi.params

        # Check parameters
        validate

        # Run process
        context = process

        # Render output
        render context
      rescue
        # Handle errors
        output "<html><head><title>Exocora Error</title></head><body>"
        output "<h1>#{$!.class}</h1>"

        output $!.to_html

        output "</body></html>"
      end
    end

    # Returns a URL for the given url and parameters
    def url_for(url = @cgi.uri, params = {})
      url + params.inject('?') do |query_string, pair|
        query_string << CGI::escape(pair[0].to_s) + '=' + CGI::escape(pair[1].to_s)
      end
    end

    # Sets the name of the template to render.
    def use_template(template)
      @template = template
    end
  
    # Returns true if the specified (or all) parameters have no errors.
    def valid?(param = nil)
      if param.nil?
        @errors.empty?
      else
        @errors[param].nil? or @errors[param].empty?
      end
    end

    # Validates CGI parameters according to @@validations.
    #
    # Parameters which fail validation have entries recorderd in @errors.
    def validate(params = @params)
      @@validations.each do |param, validations|
        validations.each do |validation|
          values = params[param]

          # If there are multiple values, check each one.
          unless values.kind_of? Array
            values = [values]
          end

#          if validation.kind_of? ValidationOfPresence
#            # Make sure we perform a validation even if no parameters are
#            # present.
#            begin
#              validation.validate values.first
#            rescue ValidationError => e
#              @errors[param] ||= []
#              @errors[param] << e
#            end
#          end

          values.each do |value|
            begin
              validation.validate(value)
            rescue ValidationError => e
              add_error param, e
            end
          end
        end
      end

      params
    end
  end
end
