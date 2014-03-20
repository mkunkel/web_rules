class Rule < ActiveRecord::Base
  validates_presence_of :text, :rule_type
end
