require 'rails_helper'

RSpec.describe 'Movies', type: :system do
  describe 'ユーザー登録画面' do
    it 'ユーザー登録の失敗' do
      visit new_user_path
      click_button('登録する')
      expect(page).to have_content('ユーザーの登録に失敗しました')
    end
    it 'ユーザー登録ができる' do
      visit new_user_path
      fill_in 'user[name]', with: 'user_1'
      fill_in 'user[email]', with: '1@example.com'
      fill_in 'user[password]', with: '1234'
      fill_in 'user[password_confirmation]', with: '1234'
      click_button('登録する')

      fill_in 'user[email]', with: '1@example.com'
      fill_in 'user[password]', with: '1234'
      click_button('ログイン')

      click_link 'user_1'
      expect(page).to have_selector(:css, '.profile-top', text: 'user_1')
      expect(page).to have_selector(:css, '.profile-top', text: 'プロフィール編集')
      expect(page).to have_selector(:css, '.profile-top', text: 'ログアウト')
    end
  end

  describe 'プロフィールページ' do
    context '未ログインユーザー' do
      it 'アクセスできない' do
        visit user_path(1)
        expect(page).to have_content('ログインしてください')
      end
    end
  end

  describe 'プロフィールページ' do
    let(:user) { create :user }
    before do
      create_list(:movie, 5)
      login(user)

      visit user_path(user)
    end
    context 'ログインユーザー' do
      it 'プロフィールの編集に失敗' do
        click_link 'プロフィール編集'
        fill_in 'user[name]', with: ""
        fill_in 'user[email]', with: ""
        click_button('更新する')

        expect(page).to have_content('プロフィールの更新に失敗しました')
      end
      it 'プロフィールの編集ができる' do
        click_link 'プロフィール編集'
        fill_in 'user[name]', with: "edit_name"
        fill_in 'user[email]', with: "edit@example.com"
        attach_file 'user[avatar]', 'spec/fixtures/rspec_test.png'
        click_button('更新する')

        expect(page).to have_selector(:css, '.profile-top', text: "edit_name")
        expect(page).to have_selector("img[src$='rspec_test.png']")
      end
      it '「観たい」リストから映画を削除できる' do
        create(:movie_status, movie_id: best_score_movie.id, user_id: user.id, status: 0)
        visit current_path

        find('.watch').click
        expect(page).not_to have_content("#{best_score_movie.title}")
      end
      it '「観た」リストから映画を削除できる' do
        create(:movie_status, movie_id: best_score_movie.id, user_id: user.id, status: 1)
        visit user_watched_path(user)

        find('.watched').click
        expect(page).not_to have_content("#{best_score_movie.title}")
      end
      it '「興味なし」リストから映画を削除できる' do
        create(:movie_status, movie_id: best_score_movie.id, user_id: user.id, status: 2)
        visit user_uninterested_path(user)

        find('.uninterested').click
        expect(page).not_to have_content("#{best_score_movie.title}")
      end
      it 'ログアウトができる' do
        click_link 'ログアウト'
        expect(page).to have_content('ログアウトしました')
      end
    end
  end
end
