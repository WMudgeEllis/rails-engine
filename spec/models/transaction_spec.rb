require "rails_helper"


RSpec.describe Transaction do
  it { should belong_to(:invoice)}
end
