ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jangle => [
  'jangle/jquery',
  'jangle/jquery-ui/jquery-ui',
  'jangle/rails',
  'jangle/plupload/plupload.min',
  'jangle/plupload/plupload.html5.min',
  'jangle/codemirror/codemirror.js',
  'jangle/cms'
]

ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :jangle => [
  'jangle/reset',
  'jangle/structure',
  'jangle/typography',
  'jangle/form',
  'jangle/content',
  '/javascripts/jangle/jquery-ui/jquery-ui'
]

ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :formtastic => [
  'jangle/formtastic',
  'jangle/formtastic_changes'
]