module ChildPublisher

  def _publish_children!(setting, opts)
    self.object_graph.each do |model, ids|
      next unless model.publishable?

      if model == Note
        filtered_ids = ids

        if setting
          # don't publish notes on this archival object, only those
          # on the child records thank you
          filtered_ids = Note
                           .filter(:id => filtered_ids)
                           .exclude(:archival_object_id => self.id)
                           .select(:id)
                           .map{|row| row[:id]}

          # Don't publish notes that contain internal-only links
          filtered_ids = Note
                           .filter(:id => filtered_ids)
                           .exclude{Sequel.like(:notes, '%https://preservica.library.yale.edu%') | Sequel.like(:notes, '%Former child record (uri=/repositories/%')}
                           .select(:id)
                           .map{|row| row[:id]}
        end

        ids = filtered_ids
      end

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
