class SimpleCrudMethodHelpers
  def self.authenticate(that, parameters)
    that.send(:authenticate_user!) if parameters[:authenticate]
  end

  def self.filter(that, query, parameters)
    return query unless parameters[:filter]

    filters = SimpleCrudHelpers.filters(that)
    query.filter(filters)
  end
end
