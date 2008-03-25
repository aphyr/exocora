module Exocora
  # Represents an error encountered in an Exocora sheet.
  class SheetError < RuntimeError
  end

  # Represents an error encountered when processing a template.
  class TemplateError < RuntimeError
  end
end
