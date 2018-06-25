module ChildPublisher

  def _publish_children!(setting, opts)
    object_graph = self.object_graph(ChildPublishing.filters.merge(opts))

    object_graph.each do |model, ids|
      next unless model.publishable?

      model.handle_publish_flag(model == self.class ? ids.reject {|i| i == self.id} : ids, setting)
    end
  end


  def publish_children!(opts = {})
    _publish_children!(true, opts)
  end


  def unpublish_children!(opts = {})
    _publish_children!(false, opts)
  end

end
