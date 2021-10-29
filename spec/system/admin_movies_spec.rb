require 'rails_helper'

RSpec.describe 'Movies', type: :system do
  describe '管理画面' do
    let(:user) { create :user }
    context '未ログインユーザー' do
      xit 'アクセスできない' do
        visit admin_root_path
        expect(page).to have_content('権限がありません')
      end
    end
    context '一般ユーザー' do
      xit 'アクセスできない' do
        login(user)
        
        visit admin_root_path
        expect(page).to have_content('権限がありません')
      end
    end
  end
  
  describe '管理画面' do
    let(:admin) { create :user, :admin }
    before do
      login(admin)
      visit admin_root_path
    end
    context '管理者ユーザー' do
      xit 'アクセスできる' do
        expect(page).to have_content('管理画面')
        expect(page).to have_content('映画一覧')
        expect(page).to have_content('ジャンル一覧')
        expect(page).to have_content('サービストップに戻る')
      end
      xit '映画の登録に失敗' do
        click_link('登録する')

        fill_in 'user_input', with: 'ボヘミアン・ラプソディ'
        click_button('検索')
        expect(page).to have_content('ボヘミアン・ラプソディ　の検索結果')
        fill_in 'movie[title]', with: ''
        click_button('登録する')

        expect(page).to have_content('映画の登録に失敗しました')

        visit admin_root_path
        expect(page).not_to have_content('ボヘミアン・ラプソディ')
      end
      xit '映画を登録できる' do
        click_link('登録する')

        fill_in 'user_input', with: 'ボヘミアン・ラプソディ'
        click_button('検索')
        expect(page).to have_content('ボヘミアン・ラプソディ　の検索結果')
        click_button('登録する')

        expect(page).to have_content('映画を登録しました')

        visit admin_root_path
        expect(page).to have_content('ボヘミアン・ラプソディ')
      end
      xit 'ジャンルを登録できる' do
        sleep(1)
        click_link('ジャンル一覧')
        sleep(1)
        click_link('登録する')

        fill_in 'genre[api_genre_id]', with: '10402'
        fill_in 'genre[name]', with: '音楽'
        click_button('登録する')
        expect(page).to have_content('ジャンルを登録しました')
        click_link('ジャンル一覧')

        expect(page).to have_content('音楽')
        expect(page).to have_content('10402')
      end
    end
  end
end
