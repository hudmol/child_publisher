PUIIndexer.class_eval do

  # Overriding to support deletes coming from the LargeTreeDocIndexer
  def index_round_complete(repository)
    # Index any trees in `repository`
    tree_types = [[:resource, :archival_object],
                  [:digital_object, :digital_object_component],
                  [:classification, :classification_term]]

    start = Time.now
    checkpoints = []

    tree_uris = []

    tree_types.each do |pair|
      root_type = pair.first
      node_type = pair.last

      checkpoints << [repository, root_type, start]
      checkpoints << [repository, node_type, start]

      last_root_node_mtime = [@state.get_last_mtime(repository.id, root_type) - @window_seconds, 0].max
      last_node_mtime = [@state.get_last_mtime(repository.id, node_type) - @window_seconds, 0].max

      root_node_ids = Set.new(JSONModel::HTTP.get_json(JSONModel(root_type).uri_for, :all_ids => true, :modified_since => last_root_node_mtime))
      node_ids = JSONModel::HTTP.get_json(JSONModel(node_type).uri_for, :all_ids => true, :modified_since => last_node_mtime)

      node_ids.each_slice(@records_per_thread) do |ids|
        node_records = JSONModel(node_type).all(:id_set => ids.join(","), 'resolve[]' => [])

        node_records.each do |record|
          root_node_ids << JSONModel.parse_reference(record[root_type.to_s]['ref']).fetch(:id)
        end
      end

      tree_uris.concat(root_node_ids.map {|id| JSONModel(root_type).uri_for(id) })
    end

    batch = IndexBatch.new

    add_infscroll_docs(tree_uris.select {|uri| JSONModel.parse_reference(uri).fetch(:type) == 'resource'},
                       batch)

    tree_indexer = LargeTreeDocIndexer.new(batch)
    tree_indexer.add_largetree_docs(tree_uris)

    if batch.length > 0
      log "Indexed #{batch.length} additional PUI records in repository #{repository.repo_code}"

      index_batch(batch, nil, :parent_id_field => 'pui_parent_id')
      send_commit
    end

    if tree_indexer.deletes.length > 0
      delete_records(tree_indexer.deletes, :parent_id_field => 'pui_parent_id')
    end

    handle_deletes(:parent_id_field => 'pui_parent_id')

    # Delete any unpublished records and decendents
    delete_records(@unpublished_records, :parent_id_field => 'pui_parent_id')
    @unpublished_records.clear()

    checkpoints.each do |repository, type, start|
      @state.set_last_mtime(repository.id, type, start)
    end

  end
end
