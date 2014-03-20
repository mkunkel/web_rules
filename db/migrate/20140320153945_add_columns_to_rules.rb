class AddColumnsToRules < ActiveRecord::Migration
  def change
    add_column :rules, :number, :string
    add_column :rules, :text, :string
    add_column :rules, :type, :string
  end
end
