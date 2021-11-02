module ApplicationHelper
  include Pagy::Frontend

  def page_title(page_title = '')
    base_title = 'シネマト - 次の「観たい」が見つかる'

    page_title.empty? ? base_title : "#{page_title}　|　#{base_title}"
  end

  def full_url(path)
    domain = if Rails.env.development?
               'http://0.0.0.0:3000'
             else
               'https://cinematrailer.herokuapp.com'
             end
    "#{domain}#{path}"
  end
end
