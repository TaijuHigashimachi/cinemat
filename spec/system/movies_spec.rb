require 'rails_helper'

RSpec.describe 'Movies', type: :system do
  let(:user) { create :user }
  before do
    create_list(:movie, 5)
  end
  describe '映画情報の表示／未ログインユーザー' do
    context 'クッキーなし' do
      it '初回チュートリアルが表示' do
        visit root_path
        expect(page).to have_content('シネマトへようこそ')
      end
      it '全作品の中で、ユーザースコアが最も高い作品が最初に表示' do
        visit root_path
        swipe_tutorial
        expect(page).to have_content("#{best_score_movie.title}")
      end
    end
    context 'クッキーあり' do
      it '前回見た作品の、次の作品が表示' do
        visit root_path
        sleep(1)
        page.driver.browser.manage.add_cookie(name: 'cinemat_movie_id', value: "#{best_score_movie.id}")
        sleep(1)

        visit current_path
        expect(page).to have_content("#{second_best_score_movie.title}")
      end
    end
  end

  describe '映画情報の表示／ログインユーザー' do
    before do
      create(:movie_status, movie_id: best_score_movie.id, user_id: user.id, status: 0)
      login(user)
    end
    context 'クッキーなし' do
      it 'ウォッチリストの作品を除いた中で、ユーザースコアが最も高い作品が表示' do
        expect(page).to have_content("#{second_best_score_movie.title}")
      end
    end
    context 'クッキーあり' do
      it 'ウォッチリストの作品を除いた中で、前回見た次の作品が表示' do
        sleep(1)
        page.driver.browser.manage.add_cookie(name: 'cinemat_movie_id', value: "#{second_best_score_movie.id}")
        sleep(1)

        visit current_path
        expect(page).to have_content("#{third_best_score_movie.title}")
      end
    end
  end

  describe 'ウォッチリスト機能／未ログインユーザー' do
    it 'ウォッチリストエリアが表示されない' do
      visit root_path
      swipe_tutorial
      sleep(1)
      expect(page).not_to have_selector(:css, '.watchlist', text: '観たい')
      expect(page).not_to have_selector(:css, '.watchlist', text: '観た')
      expect(page).not_to have_selector(:css, '.watchlist', text: '興味なし')
    end
  end

  describe 'ウォッチリスト機能／ログインユーザー' do
    before do
      login(user)
    end
    it 'ウォッチリストエリアが表示されている' do
      expect(page).to have_selector(:css, '.watchlist', text: '観たい')
      expect(page).to have_selector(:css, '.watchlist', text: '観た')
      expect(page).to have_selector(:css, '.watchlist', text: '興味なし')
    end
    it '「観たい」リストに追加ができる' do
      find('.watch').click

      visit user_path(user)
      expect(page).to have_content("#{best_score_movie.title}")
    end
    it '「観た」リストに追加ができる' do
      find('.watched').click

      visit user_watched_path(user)
      expect(page).to have_content("#{best_score_movie.title}")
    end
    it '「興味なし」リストに追加ができる' do
      find('.uninterested').click

      visit user_uninterested_path(user)
      expect(page).to have_content("#{best_score_movie.title}")
    end
    it 'ステータスが変更できる' do
      find('.watch').click

      visit user_path(user)
      expect(page).to have_content("#{best_score_movie.title}")
      find('.watched').click
      expect(page).not_to have_content("#{best_score_movie.title}")

      visit user_watched_path(user)
      expect(page).to have_content("#{best_score_movie.title}")
      find('.uninterested').click
      expect(page).not_to have_content("#{best_score_movie.title}")

      visit user_uninterested_path(user)
      expect(page).to have_content("#{best_score_movie.title}")
      find('.watch').click
      expect(page).not_to have_content("#{best_score_movie.title}")

      visit user_path(user)
      expect(page).to have_content("#{best_score_movie.title}")
    end
  end
end
