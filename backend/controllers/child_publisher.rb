class ArchivesSpaceService < Sinatra::Base

  Endpoint.post('/repositories/:repo_id/archival_objects/:id/publish_children')
  .description("Publish all sub-records and components of this Archival Object")
  .params(["id", :id],
          ["repo_id", :repo_id])
  .permissions([:update_resource_record])
  .returns([200, :updated],
           [400, :error]) \
  do
    ao = ArchivalObject.get_or_die(params[:id])
    ao.publish_children!
    updated_response(ao)
  end


  Endpoint.post('/repositories/:repo_id/archival_objects/:id/unpublish_children')
  .description("Unpublish all sub-records and components of this Archival Object")
  .params(["id", :id],
          ["repo_id", :repo_id])
  .permissions([:update_resource_record])
  .returns([200, :updated],
           [400, :error]) \
  do
    ao = ArchivalObject.get_or_die(params[:id])
    ao.unpublish_children!
    updated_response(ao)
  end

end
