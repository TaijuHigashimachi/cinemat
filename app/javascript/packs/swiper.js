import Swiper from 'swiper/swiper-bundle';
import 'swiper/swiper-bundle.css';

const swiper = new Swiper('.swiper', {
  loop: true,

  pagination: { 
    el: '.swiper-pagination',
    type: 'bullets',
    clickable: true,
  },

  navigation: { 
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },

  scrollbar: { 
    el: '.swiper-scrollbar',
  },
});
