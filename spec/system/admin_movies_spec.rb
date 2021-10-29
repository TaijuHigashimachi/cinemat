require 'rails_helper'

RSpec.describe 'Movies', type: :system do
  describe '管理画面' do
    let(:user) { create :user }
    context '未ログインユーザー' do
      it 'アクセスに失敗' do
        visit admin_root_path
        expect(page).to have_content('権限がありません')
      end
    end
    context '一般ユーザー' do
      it 'アクセスに失敗' do
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
      it 'アクセスに成功' do
        expect(page).to have_content('管理画面')
        expect(page).to have_content('映画一覧')
        expect(page).to have_content('ジャンル一覧')
        expect(page).to have_content('サービストップに戻る')
      end
      it '映画の登録に失敗' do
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
      it '映画の登録に成功' do
        click_link('登録する')

        fill_in 'user_input', with: 'ボヘミアン・ラプソディ'
        click_button('検索')
        expect(page).to have_content('ボヘミアン・ラプソディ　の検索結果')
        click_button('登録する')

        expect(page).to have_content('映画を登録しました')

        visit admin_root_path
        expect(page).to have_content('ボヘミアン・ラプソディ')
      end
      it '映画情報の更新に失敗' do
        create(:movie)
        visit current_path
        click_link '編集'
        fill_in 'movie[title]', with: ''
        click_button('更新')
        expect(page).to have_content('作品名を入力してください')
      end
      it '映画情報の更新に成功' do
        create(:movie)
        visit current_path
        click_link '編集'
        fill_in 'movie[title]', with: 'movie_title_edit'
        click_button('更新')
        expect(page).to have_content('映画を更新しました')
      end
      it '映画の削除に成功' do
        create(:movie)
        visit current_path
        click_link '削除'
        expect(page.accept_confirm).to eq '削除してもよろしいですか？'
        expect(page).to have_content('映画を削除しました')
      end
      it 'ジャンルの登録に失敗' do
        sleep(1)
        click_link('ジャンル一覧')
        sleep(1)
        click_link('登録する')

        click_button('登録する')
        expect(page).to have_content('ジャンルを登録できませんでした')
      end
      it 'ジャンルの登録に成功' do
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
      it 'ジャンルの編集に失敗' do
        create(:genre)
        click_link('ジャンル一覧')
        sleep(1)
        click_link('編集')

        fill_in 'genre[api_genre_id]', with: ''
        fill_in 'genre[name]', with: ''
        click_button('更新する')

        expect(page).to have_content('API_Genre_IDを入力してください')
        expect(page).to have_content('ジャンル名を入力してください')
      end
      it 'ジャンルの編集に成功' do
        create(:genre)
        click_link('ジャンル一覧')
        sleep(1)
        click_link('編集')

        fill_in 'genre[api_genre_id]', with: '0'
        fill_in 'genre[name]', with: 'test_genre'
        click_button('更新する')

        expect(page).to have_content('ジャンルを更新しました')
        expect(page).to have_content('test_genre')
      end
      it 'ジャンルの削除に成功' do
        create(:genre)
        click_link('ジャンル一覧')
        sleep(1)
        click_link('削除')
        expect(page.accept_confirm).to eq '削除してもよろしいですか？'

        expect(page).to have_content('ジャンルを削除しました')
        expect(page).not_to have_content('test_genre')
      end
    end
  end
end
