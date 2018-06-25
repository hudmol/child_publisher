module ObjectGraph
  module ClassMethods

    def calculate_object_graph(object_graph, opts = {})

      object_graph.models.each do |model|
        next unless model.respond_to?(:nested_records)
        model.nested_records.each do |nr|
          association =  nr[:association]

          if association[:type] != :many_to_many
            nested_model = Kernel.const_get(association[:class_name])

            ids = (opts[nested_model] || nested_model).filter(association[:key] => object_graph.ids_for(model)).
                                                       select(:id).map {|row|
              row[:id]
            }

            object_graph.add_objects(nested_model, ids)
          end
        end
      end

      object_graph
    end

  end

end
