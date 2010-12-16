(function($) {
  var whatWeDo = $('section#what-we-do'),
    topLeft = $('img#top-left-arrow'),
    topRight = $('img#top-right-arrow'),
    bottomLeft = $('img#bottom-left-arrow'),
    bottomRight = $('img#bottom-right-arrow'),
    prototyping = $('section#prototyping'),
    webdev = $('section#web-development'),
    design = $('section#design'),
    consulting = $('section#consulting'),
    cool = (Modernizr.csstransforms && Modernizr.fontface),
    iDevice = !!navigator.userAgent.match(/iPhone|iPad/);
  
  if (!cool || iDevice) return false;

  $(window).resize(function() {
    var offset = whatWeDo.offset();
    
    var points = {
      topLeft: {
        left:   (offset.left - ($(topLeft).outerWidth() / 100 * 120)),
        top:    (offset.top - ($(topLeft).outerHeight() / 100 * 90)),
        height: ((offset.top) - (prototyping.offset().top + prototyping.outerHeight())),
        width:  (offset.left - (prototyping.offset().left + (prototyping.outerWidth() / 100 * 50)))
      },
      topRight: {
        left: (offset.left + (whatWeDo.outerWidth() / 100 * 90)),
        top: (offset.top - $(topRight).outerHeight()),
        height: (offset.top - (design.offset().top + design.outerHeight())),
        width: ((design.offset().left + (design.outerWidth() / 100 * 65)) - (offset.left + whatWeDo.outerWidth()))
      },
      bottomLeft: {
        left: (offset.left - ($(bottomLeft).outerWidth() / 100 * 120)),
        top: (offset.top + (whatWeDo.outerHeight() / 100 * 90)),
        height: ((webdev.offset().top) - (offset.top + (webdev.outerHeight() / 100 * 130))),
        width: ((offset.left + (webdev.outerWidth() / 100 * 50)) - (offset.left + whatWeDo.outerWidth()))
      },
      bottomRight: {
        left: (offset.left + (whatWeDo.outerWidth() / 100 * 80)),
        top: (offset.top + (whatWeDo.outerHeight() / 100 * 90)),
        height: ((consulting.offset().top) - (offset.top + consulting.outerHeight())),
        width: ((consulting.offset().left + (consulting.outerWidth())) - (offset.left + whatWeDo.outerWidth()))
      }
    }
    
    $(topLeft).css({
      left: points.topLeft.left,
      top: points.topLeft.top,
      height: points.topLeft.height,
      width: points.topLeft.width
    });

    $(topRight).css({
      left: points.topRight.left,
      top: points.topRight.top,
      height: points.topRight.height,
      width: points.topRight.width
    });

    $(bottomLeft).css({
      left: points.bottomLeft.left,
      top: points.bottomLeft.top,
      height: points.bottomLeft.height,
      width: points.bottomLeft.width
    });

    $(bottomRight).css({
      left: points.bottomRight.left,
      top: points.bottomRight.top,
      height: points.bottomRight.height,
      width: points.bottomRight.width
    });
  });
  
  $('section > h1 > a').toggle(
    function(e) {
      $('section > h1 > a.active').trigger('click').removeClass('active');
      $(this).addClass('active');
      $(this).parents('section')
        .find('hr').fadeIn().end()
        .find('ul').slideDown(300);
    },
    function() {
      $(this).removeClass('active');
      $(this).parents('section')
        .find('hr').fadeOut(100).end()
        .find('ul').slideUp(100);
    }
  );
  
  $('body').click(function(e) {
    if (e.target == this) $('section > h1 > a.active').trigger('click');
  });

  $(window).load(function() {
    setTimeout(function() {
      $('img.arrow').show();
      $(window).trigger('resize');
    }, 300);
  });
  $(window).trigger('resize');
  return true;
})(jQuery);