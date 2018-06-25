class ChildPublisherController < ApplicationController

  set_access_control  "update_resource_record" => [:publish_children, :unpublish_children]


  def publish_children
    _publish_children(params[:uri], true)
  end


  def unpublish_children
    _publish_children(params[:uri], false)
  end


  def _publish_children(uri, setting)
    ep = setting ? 'publish_children' : 'unpublish_children'

    response = JSONModel::HTTP.post_form("#{uri}/#{ep}")

    if response.code == '200'
      flash[:success] = I18n.t("plugins.child_publisher.messages.#{setting ? 'published' : 'unpublished'}")
    else
      flash[:error] = ASUtils.json_parse(response.body)['error'].to_s
    end

    redirect_to request.referer + "#tree::archival_object_#{uri.sub(/.*\//, '')}"
  end

end
