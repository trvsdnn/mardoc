class String
  def titlecase
    self.gsub(/[_\s-]+/, ' ').gsub(/\b([a-z])/) { $1.capitalize }
  end
end