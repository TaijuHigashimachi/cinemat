module ApplicationHelper
  include Pagy::Frontend

  def page_title(page_title = '')
    base_title = 'シネマト - 映画の予告をもっと楽しむ'

    page_title.empty? ? base_title : page_title + '　|　' + base_title
  end
end
