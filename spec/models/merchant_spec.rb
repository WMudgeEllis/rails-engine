require "rails_helper"

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  it 'can find all merchants' do
    merchant1 = create(:merchant, name: 'Turing')
    merchant2 = create(:merchant, name: 'Ring world')
    create_list(:merchant, 10)
    expect(Merchant.find_all('ring')).to eq([merchant1, merchant2])
  end
end
