import InfiniteScroll from 'infinite-scroll';

let infScroll = new InfiniteScroll( '.container', {
  path: 'nav.pagy-bootstrap-nav a[rel=next]',
  append: '.movie-area',
  prefill: false,
  history: false,
  hideNav: '.pagy-bootstrap-nav'
})
