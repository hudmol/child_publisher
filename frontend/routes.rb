ArchivesSpace::Application.routes.draw do

  [AppConfig[:frontend_proxy_prefix], AppConfig[:frontend_prefix]].uniq.each do |prefix|

    scope prefix do
      match('/plugins/child_publisher/publish_children' => 'child_publisher#publish_children', :via => [:get])
      match('/plugins/child_publisher/unpublish_children' => 'child_publisher#unpublish_children', :via => [:get])
    end
  end
end
