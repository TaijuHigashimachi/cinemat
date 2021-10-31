module LoginMacros
  def login(user)
    visit login_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: '123456'
    click_button('ログイン')
  end
end