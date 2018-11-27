module ChildPublisher

  def _publish_children!(setting, opts)
    filters = ChildPublishing.filters.merge(opts)
    filters[Note] = filters[Note].exclude(:archival_object_id => self.id) unless setting

    object_graph = self.object_graph(filters)

    object_graph.each do |model, ids|
      next unless model.publishable?

      model.handle_publish_flag(model == self.class && !setting ? ids.reject {|i| i == self.id} : ids, setting)
    end
  end


  def publish_children!(opts = {})
    _publish_children!(true, opts)
  end


  def unpublish_children!(opts = {})
    _publish_children!(false, opts)
  end

end
