# workaround for plugins' scope problem
require_dependency 'suppliers_plugin/display_helper'
SuppliersPlugin::SuppliersDisplayHelper = SuppliersPlugin::DisplayHelper

class SuppliersPluginProductController < MyProfileController

  no_design_blocks

  include SuppliersPlugin::TranslationHelper

  protect 'edit_profile', :profile

  helper SuppliersPlugin::TranslationHelper
  helper SuppliersPlugin::SuppliersDisplayHelper

  def index
    @supplier = SuppliersPlugin::Supplier.find_by_id params[:supplier_id] if params[:supplier_id].present?

    SuppliersPlugin::DistributedProduct.send :with_exclusive_scope do
      scope = profile.distributed_products.unarchived.from_products_joins
      @products = search_scope(scope).paginate :per_page => 10, :page => params[:page], :order => 'from_products_products.name ASC'
      @products_count = search_scope(scope).count
    end
    @product_categories = Product.product_categories_of @products
    @new_product = SuppliersPlugin::DistributedProduct.new :profile => profile, :supplier => @supplier
    @units = Unit.all

    respond_to do |format|
      format.html
      format.js { render :partial => 'suppliers_plugin_product/search' }
    end
  end

  def edit
    @product = SuppliersPlugin::DistributedProduct.find params[:id]
    @product.update_attributes params["product_#{@product.id}"]
  end

  def destroy
    @product = SuppliersPlugin::DistributedProduct.find params[:id]
    @product.destroy
    flash[:notice] = t('suppliers_plugin.controllers.myprofile.product_controller.product_removed_succe')
  end

  protected

  def search_scope scope
    scope = scope.from_supplier_id params[:supplier_id] if params[:supplier_id].present?
    scope = scope.with_available params[:available] if params[:available].present?
    scope = scope.name_like params[:name] if params[:name].present?
    scope = scope.with_product_category_id params[:category_id] if params[:category_id].present?
    scope
  end

end
