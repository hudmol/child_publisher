module Notes
  module ClassMethods
    def calculate_object_graph(object_graph, opts = {})
      super

      column = "#{self.table_name}_id".intern

      ids = (opts[Note] || Note).filter(column => object_graph.ids_for(self)).
        map {|row| row[:id]}

      object_graph.add_objects(Note, ids)
    end
  end
end
