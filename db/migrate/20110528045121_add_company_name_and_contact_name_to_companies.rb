class AddCompanyNameAndContactNameToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :company_name, :string
    add_column :companies, :contact_name, :string
  end

  def self.down
    remove_column :companies, :contact_name
    remove_column :companies, :company_name
  end
end
