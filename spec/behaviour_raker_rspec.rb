require 'spec_helper'

RSpec.describe Racker do

  before { visit '/' }

  it '/' do
    expect(page).to have_link('Scores')
    expect(page).to have_link('New game')
  end

  context '/scores' do
    before do
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
      click_link('New game')
    end

    specify { expect(page).to have_current_path('/new_game') }
    specify { expect(page).to have_content('Type your guess') }
    specify { expect(page).to have_button('Guess') }
    specify { expect(page).to have_link('Hint') }
    specify { expect(page).to have_link('Restart') }
    specify { expect(page).not_to have_content('WARNING!')}
    specify { expect(page).to have_content('You have 2 hints.') }
    specify { expect(page).to have_content('You have 7 guesses.') }

    context 'click on page links' do
      it 'should show warning' do
        click_button('Guess')
        expect(page).to have_content('WARNING!')
      end

      it 'should decrease hints quantity' do
        click_link('Hint')
        expect(page).to have_content('You have 1 hints.')
        expect(page).to have_content('Hint gets')
      end

      it 'should restart game' do
        click_link('Hint')
        click_link('Restart')
        expect(page).to have_content('You have 2 hints.')
      end
    end

    context 'decrease guess quantity' do
      before do
        fill_in with: '1324'
        click_button 'Guess'
      end

      specify { expect(page).to have_content('You have 6 guesses.') }
    end
  end

  context '/complete_game' do
    before do
      click_link('New game')
      7.times do
        fill_in with: '1324'
        click_button 'Guess'
      end
    end

    specify { expect(page).to have_current_path('/guess') }
    specify { expect(page).to have_content('Secret code:') }
    specify { expect(page).to have_content('Your result is:') }
    specify { expect(page).to have_content('Would you like to save your result?') }
    specify { expect(page).to have_link('Yes') }
    specify { expect(page).to have_link('No') }

    context 'click Yes' do
      before { click_link 'Yes' }

      specify { expect(page).to have_content('Type your name') }
      specify { expect(page).to have_button('Submit') }

      it 'should redirect to this page' do
        click_button 'Submit'
        expect(page).to have_content('Type your name')
      end

      context 'fill in name' do
        before { fill_in with: 'Lorem Ipsum' }

        it 'should get question about repeate' do
          click_button 'Submit'
          expect(page).to have_content('Would you like to paly again?')
          expect(page).to have_link('Yes')
          expect(page).to have_link('No')
        end

        context 'repeate' do
          before { click_button 'Submit' }

          context 'click No' do
            before { click_link 'No' }

            specify { expect(page).to have_link('New game') }
            specify { expect(page).to have_link('Scores') }

            context 'Scores' do
              before { click_link 'Scores' }
              specify { expect(page).to have_content('Lorem Ipsum') }
            end
          end

          context 'click Yes' do
            before { click_link 'Yes' }

            specify { expect(page).to have_content('Type your guess') }
            specify { expect(page).to have_button('Guess') }
          end
        end
      end
    end

    it 'click no' do
      click_link('No')
      expect(page).to have_link('New game')
      expect(page).to have_link('Scores')
    end
  end
end