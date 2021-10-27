require 'rails_helper'

RSpec.describe 'Movies', type: :system do
  describe 'トップページ' do
    context '未ログインユーザー x クッキーなし' do
      fit '初回チュートリアルが表示' do
        create_list(:movie, 5)
        visit root_path
        expect(page).to have_content('シネマトへようこそ')
      end
      xit '全作品の中で、ユーザースコアが最も高い作品が最初に表示' do
        visit root_path
      end
    end
    context '未ログインユーザー x クッキーあり' do
      it '前回見た作品の、次の作品が表示' do
      end
    end
    context 'ログインユーザー x クッキーなし' do
      it 'ウォッチリストの作品を除いた中で、ユーザースコアが最も高い作品が表示' do
      end
    end
    context 'ログインユーザー x クッキーあり' do
      it 'ウォッチリストの作品を除いた中で、前回見た次の作品が表示' do
      end
    end
  end
end
