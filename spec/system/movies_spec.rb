require 'rails_helper'

RSpec.describe 'Movies', type: :system do
  let(:user) { create :user }
  before do
    create_list(:movie, 5)
  end
  describe '映画情報の表示' do
    context '未ログインユーザー x クッキーなし' do
      xit '初回チュートリアルが表示' do
        visit root_path
        expect(page).to have_content('シネマトへようこそ')
      end
      xit '全作品の中で、ユーザースコアが最も高い作品が最初に表示' do
        visit root_path
        swipe_tutorial
        expect(page).to have_content("#{best_score_movie.title}")
      end
    end
    context '未ログインユーザー x クッキーあり' do
      xit '前回見た作品の、次の作品が表示' do
        visit root_path
        sleep(1)
        page.driver.browser.manage.add_cookie(name: 'cinemat_movie_id', value: "#{best_score_movie.id}")
        sleep(1)
        visit current_path
        expect(page).to have_content("#{second_best_score_movie.title}")
      end
    end
    before do
      create(:movie_status, movie_id: best_score_movie.id, user_id: user.id, status: 0)
      login(user)
    end
    context 'ログインユーザー x クッキーなし' do
      xit 'ウォッチリストの作品を除いた中で、ユーザースコアが最も高い作品が表示' do
        expect(page).to have_content("#{second_best_score_movie.title}")
      end
    end
    context 'ログインユーザー x クッキーあり' do
      xit 'ウォッチリストの作品を除いた中で、前回見た次の作品が表示' do
        sleep(1)
        page.driver.browser.manage.add_cookie(name: 'cinemat_movie_id', value: "#{second_best_score_movie.id}")
        sleep(1)
        visit current_path
        expect(page).to have_content("#{third_best_score_movie.title}")
      end
    end
  end
