module Exocora
  # Validates a parameter. If a block is provided, the block is applied to
  # values passed to apply; the return value determines if the value is valid.
  # Otherwise, compares filter === value.
  
  class Validation
    attr_accessor :message, :filter, :negate

    def initialize(filter = Object, message = 'must be valid')
      @filter = filter
      @message = message
      @negate = false
    end

    # Change the message given when this validation fails.
    def note(message)
      @message = message
      self
    end 
   
    def to_s
      "#{@message} #{@negate ? 'unless' : 'when'} #{@filter.inspect}"
    end

    # Adds the opposite of this filter
    def unless(filter)
      @filter = filter
      @negate = true
      self
    end

    # Applies this validation to a valie. Returns true, or raises a
    # ValidationError.
    def validate(value)
      # Treat the filter as a function or a rubric
      if @filter.respond_to? :call
        method = :call
      else
        method = :===
      end

      # Check the value
      begin
        result = @filter.send method, value
      rescue
        result = false
      end

      # If we're a negative filter, negate the result
      if negate
        result = ! result
      end

      # Return
      if result
        value
      else
        raise ValidationError.new(value, @message)
      end
    end

    # Sets the filter used
    def if(filter)
      @filter = filter
      @negate = false
      self
    end

    alias :with :if
    alias :when :if
  end
end
