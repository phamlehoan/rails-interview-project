class AddNumberOfTenantRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :number_of_requests, :integer, default: 0
  end
end
