class Rule < ActiveRecord::Base
  validates_presence_of :text, :type
end
