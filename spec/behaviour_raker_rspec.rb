require 'spec_helper'

RSpec.describe Racker do
  it '/' do
    visit '/'
    expect(page).to have_link('Scores')
    expect(page).to have_link('New game')
  end

  context '/scores' do
    before do
      visit '/'
      click_link('Scores')
    end

    specify { expect(page).to have_link('Menu') }
    specify { expect(page).not_to have_link('New game') }
    specify { expect(page).not_to have_link('Scores') }
    specify { expect(page).to have_current_path('/scores') }
    
    it 'should return to menu' do
      click_link('Menu')
      expect(page).to have_link('New game')
      expect(page).to have_current_path('/')
    end
  end

  context '/new_game' do
    before do
      visit '/'
      click_link('New game')
    end

    specify { expect(page).to have_current_path('/new_game') }
    specify { expect(page).to have_content('Type your guess') }
    specify { expect(page).to have_button('Guess') }
    specify { expect(page).to have_link('Hint') }
    specify { expect(page).to have_link('Restart') }
    specify { expect(page).not_to have_content('WARNING!')}
    specify { expect(page).to have_content('You have 2 hints.') }

    context 'click on game links' do
      it 'should show warning' do
        click_button('Guess')
        expect(page).to have_content('WARNING!')
      end

      it 'should decrease hints quantity' do
        click_link('Hint')
        expect(page).to have_content('You have 1 hints.')
        expect(page).to have_content('Hint gets')
      end
    end
  end
end