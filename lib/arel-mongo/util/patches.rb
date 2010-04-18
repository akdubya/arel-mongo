class Hash
  def bind(relation)
    Arel::Value.new(self, relation)
  end
end