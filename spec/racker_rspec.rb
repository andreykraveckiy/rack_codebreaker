require 'spec_helper'

RSpec.describe Racker do
  subject { Rack::MockRequest.new(Racker) }

  specify 'get responce 200' do
    expect(subject.get('/').status).to eq 200
  end

  specify 'get responce body with "chose option"' do
    expect(subject.get('/').body).to match(/<p>Choose the option<\/p>/)
  end
end