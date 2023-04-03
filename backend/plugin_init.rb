
ChildPublishing.add_filter(Note.exclude{Sequel.like(:notes, '%"content":"https://preservica.library.yale.edu%') | Sequel.like(:notes, '%Former child record (uri=/repositories/%')})

ArchivalObject.include(ChildPublisher)

Resource.class_eval do
  def publish!(setting = true)
    object_graph = self.object_graph(ChildPublishing.filters)

    object_graph.each do |model, ids|
      next unless model.publishable?

      model.handle_publish_flag(ids, setting)
    end
  end
end
