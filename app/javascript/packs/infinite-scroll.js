import InfiniteScroll from 'infinite-scroll';

let infScroll = new InfiniteScroll( '.container', {
  path: 'a[rel=next]',
  append: '.infinite-scroll-area',
  prefill: false,
  history: false,
  hideNav: '.pagy-bootstrap-nav'
})
