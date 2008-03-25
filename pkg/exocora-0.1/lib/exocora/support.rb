module Exocora
  module Support
    # An empty class to support #bind.
    class Binder
      def bind(variables = {})
        if variables
          # Set each variable
          variables.each do |name, value|
            instance_variable_set '@' + name.to_s, value
          end
          variables = nil
        end

        binding
      end
    end

    # Returns a binding of a hash as instance variables.
    # Turns {a => 2} into a binding where @a = 2.
    def self.bind(variables = {})
      Binder.new().bind(variables)
    end
  end
end
