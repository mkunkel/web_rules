class ChangeTypeToRuleType < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        rename_column :rules, :type, :rule_type
      end
      dir.down do
        rename_column :rules, :rule_type, :type
      end
    end
  end
end
