module ApplicationHelper
  include Pagy::Frontend

  def page_title(page_title = '')
    base_title = 'シネマト - 映画の予告をもっと楽しむ'

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
