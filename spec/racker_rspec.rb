require 'spec_helper'

RSpec.describe Racker do
  subject! { Rack::MockRequest.new(Racker) }

  specify 'get responce 200' do
    expect(subject.get('/').status).to eq 200
  end

  specify 'get responce body with "chose option"' do
    expect(subject.get('/').body).to match(/<p>Choose the option<\/p>/)
  end

  context "stage scores" do
    specify 'post /scores return scores table' do
      expect(subject.post("/scores").body).to match(/<table>/)
    end
  end

  context "stage new_game" do
    specify 'post /new_game return new game' do
      expect(subject.post('/new_game').body).to match(/Type your guess/)
    end

    context 'actions of game' do
      before do
        allow_any_instance_of(Codebreaker::GameProcess).to receive(:stage).and_return(:game) 
      end
      it { expect(subject.post('/hint').body).to match(/Hint gets/) }
      it do 
        allow_any_instance_of(Codebreaker::GameProcess).to receive(:remaining_guess).and_return('7')
        expect(subject.post('/restart').body).to match(/7 guesses/) 
      end
    end
  end

  context "stage complete game" do
    before do
      allow_any_instance_of(Codebreaker::GameProcess).to receive(:stage).and_return(:complete_game)
      allow_any_instance_of(Codebreaker::GameProcess).to receive(:answers).and_return({result: "LOSE", secret: "1324", attemts: 7, hints: 2 })
    end

    it { expect(subject.post("/").body).to match(/Your result is:/) }
  end

  context "stage save score" do
    before do
      allow_any_instance_of(Codebreaker::GameProcess).to receive(:stage).and_return(:save_score)
    end

    it { expect(subject.post("/").body).to match(/Type your name/) }
  end

  context "stage repeate" do
    before do
      allow_any_instance_of(Codebreaker::GameProcess).to receive(:stage).and_return(:repeate)
    end

    it { expect(subject.post("/").body).to match(/Would you like to paly again?/) }
  end
end