require 'spec_helper'

RSpec.describe Racker do
  subject { Rack::MockRequest.new(Racker) }

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

    context 'post /back returns menu' do
      before { subject.post("/scores") }
      it { expect(subject.post("/back").body).to match(/Choose the option/) } 
    end
  end

  context "stage new_game" do
    specify 'post /new_game return new game' do
      expect(subject.post('/new_game').body).to match(/Type your guess/)
    end

    context 'actions of game' do
      before { subject.post("/new_game") }
      it { expect(subject.post("/hint").body).to match(/Hint gets/) }
      it { expect(subject.post("/restart").body).to match(/7 guesses/) }
      it { expect(subject.post("/guess", { guess: "1234" }).body).to match(/6 guesses/) }
    end
  end

  context "stage complete game" do
    before do
      subject.post("/new_game")
      6.times do
        subject.post("/guess", { guess: "1234" })
      end
    end

    it { expect(subject.post("/guess", { guess: "1234" }).body).to match(/Your result is:/) }

    context 'actions of comlete game' do
      before { subject.post("/guess", { guess: "1234" }) }
      it { expect(subject.post("/yes").body).to match(/Type your name/) }
      it { expect(subject.post("/no").body).to match(/Choose the option/) }
    end
  end

  context "stage save score" do
    before do
      subject.post("/new_game")
      7.times do
        subject.post("/guess", { guess: "1234" })
      end
      subject.post("/yes")
    end

    it { expect(subject.post("/save", { user_name: "Karkoziabra" }).body).to match(/Would you like to paly again?/) }
  end

  context "stage repeate" do
    before do
      subject.post("/new_game")
      7.times do
        subject.post("/guess", { guess: "1234" })
      end
      subject.post("/yes")
      subject.post("/save", { user_name: "Karkoziabra" })
    end

    it { expect(subject.post("/yes").body).to match(/Type your guess/) }
    it { expect(subject.post("/no").body).to match(/Choose the option/) }
  end
end