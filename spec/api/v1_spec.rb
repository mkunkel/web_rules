require 'spec_helper'

describe "v1 api" do

  context 'attributes' do
    it { should have_db_column(:number) }
    it { should have_db_column(:text) }
    it { should have_db_column(:rule_type) }
  end

  context 'scopes' do

  end

  context 'class methods' do

  end

  context 'validations' do
    it { should_not validate_presence_of(:number) }
    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:rule_type) }
  end
end
