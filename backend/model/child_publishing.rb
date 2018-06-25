class ChildPublishing

  @@filters = {}

  def self.add_filter(filter)
    @@filters[filter.respond_to?(:model) ? filter.model : filter] = filter
  end

  def self.filters
    @@filters
  end
end
