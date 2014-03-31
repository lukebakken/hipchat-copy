class NilClass
  def nil_or_empty?
    true
  end
end

class String
  def nil_or_empty?
    empty?
  end
end

