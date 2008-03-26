class Array
  # Convert an array to a nice sentence. Method is called on each element of the array, and should return a string.
  def to_sentence(method = :to_s)
    case size
    when 0
      ''
    when 1
      first.send method
    when 2
      first.send(method) + ' and ' + last.send(method)
    else
      sentence = self[1..-2].inject(first.send(method)) do |sentence, element|
        sentence += ', ' + element.send(method)
      end
      sentence + ', and ' + last.send(method)
    end
  end
end
