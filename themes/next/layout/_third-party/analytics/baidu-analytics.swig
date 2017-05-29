{% if theme.baidu_analytics %}
  <script type="text/javascript">
    var _hmt = _hmt || [];
    (function() {
      var hm = document.createElement("script");
      hm.src = "//hm.baidu.com/hm.js?{{ theme.baidu_analytics }}";
      if( /blog.guowenfh.com/i.test(window.location.href)){
        // 新博客的统计
        hm.src = "//hm.baidu.com/hm.js?ec7ff4fe4cfe8e9b6c51e1b8e7a47b8b";
      }
      var s = document.getElementsByTagName("script")[0];
      s.parentNode.insertBefore(hm, s);
    })();
  </script>
{% endif %}
