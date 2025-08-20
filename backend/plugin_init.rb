
ArchivalObject.include(ChildPublisher)

Resource.class_eval do
  def publish!(setting = true)
    self.object_graph.each do |model, ids|
      next unless model.publishable?

      if setting && model == Note
        filtered_ids = Note
                         .filter(:id => ids)
                         .exclude{Sequel.like(:notes, '%https://preservica.library.yale.edu%') | Sequel.like(:notes, '%Former child record (uri=/repositories/%')}
                         .select(:id)
                         .map{|row| row[:id]}

        ids = filtered_ids
      end

      model.handle_publish_flag(ids, setting)
    end
  end
end
