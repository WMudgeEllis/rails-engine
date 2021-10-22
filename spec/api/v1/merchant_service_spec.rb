require "rails_helper"

RSpec.describe 'Merchant api services' do
  it 'can return a set of merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful
  end
end
