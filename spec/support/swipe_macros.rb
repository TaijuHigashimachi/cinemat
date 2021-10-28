module SwipeMacros
  def swipe_tutorial
    3.times do
      source = page.find('.swiper-slide-active')
      page.driver.browser.action.drag_and_drop_by(source.native, 0, -100).perform
      sleep(1)
    end
  end

  def swipe_movie
    source = page.find('.selenium-movie-title')
    page.driver.browser.action.drag_and_drop_by(source.native, 0, -1).perform
    sleep(1)
  end
end