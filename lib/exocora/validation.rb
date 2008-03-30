module Exocora
  # Validates a parameter. If a block is provided, the block is applied to
  # values passed to apply; the return value determines if the value is valid.
  # Otherwise, compares filter === value.
  
  class Validation
    DEFAULT_MESSAGE = 'must be present'

    attr_accessor :message, :filter, :negate

    def initialize(filter=Object, message=DEFAULT_MESSAGE)
      @filter = filter
      @message = message
      @negate = false
    end

    # Change the message given when this validation fails.
    def because(message)
      @message = message
      self
    end
    alias :explain :because
   
    def to_s
      "#{@message} #{@negate ? 'unless' : 'when'} #{@filter.inspect}"
    end

    # Adds the opposite of this filter
    def unless(filter, &block)
      @filter = block_given? ? block : filter
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
    def if(filter, &block)
      @filter = block_given? ? block : filter
      @negate = false
      self
    end

    alias :with :if
    alias :when :if
  end

  # ValidationOfPresence is a special validation which ensures its value
  # is both present and non-empty.
  class ValidationOfPresence < Validation
    DEFAULT_MESSAGE = 'must be present'

    def initialize(message=DEFAULT_MESSAGE)
      @message = message
    end

    def validate(value = nil)
      if value.nil? or (value.respond_to? :empty? and value.empty?)
        raise ValidationError.new(value, @message)
      else
        value
      end
    end
  end
end
