module SuppliersPlugin::DisplayHelper

  protected

  include SearchHelper

  include SuppliersPlugin::TermsHelper
  include SuppliersPlugin::TableHelper
  include SuppliersPlugin::FieldHelper
  include SuppliersPlugin::ProductHelper
  include SuppliersPlugin::ImageHelper
  include SuppliersPlugin::JavascriptHelper

end
