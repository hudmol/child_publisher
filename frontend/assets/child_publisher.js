var setupButton = function(templ, uri) {
  $publish = $(AS.renderTemplate(templ));
  var href = $publish.attr('href').replace('CP_AO_URI', uri);
  $publish.attr('href', href);
  $('#other-dropdown .dropdown-menu').append($('<li />').append($publish));
  $('#other-dropdown').show();
};


$(document).on("loadedrecordform.aspace", function(event, $container) {
  if (tree && tree.current().data('jsonmodel_type') == 'archival_object') {
      var uri = tree.current().data('uri');
      setupButton("childPublisherPublishButtonTemplate", uri);
      setupButton("childPublisherUnpublishButtonTemplate", uri);
  }
});
