{% if theme.blog_migration_new_url %}
  <script type="text/javascript">
    (function() {
        var oldUrl = window.location.href;
        if(/https{0,1}\:\/\/(guowenfh.github.io|guowenfh.com)/i.test(oldUrl)){
          window.location.href = oldUrl.replace(/https{0,1}\:\/\/(guowenfh.github.io|guowenfh.com)/i,'http://blog.guowenfh.com');
        }
        if( /blog.guowenfh.com/i.test(window.location.href)  && localStorage.getItem('click-top-inform')!=='click'){
          var wrap = document.body;
          var content = document.createElement('div');
          content.innerHTML= '为了方便管理，本博客已购买该域名，访问原站，将自动跳转至该新地址。（点击此处删除该提示）';
          content.style.textAlign = 'center';
          content.style.color = 'red';
          content.style.position = 'relative';
          content.style.padding = '10px 20px';
          content.className = "blog-top-inform";
          content.addEventListener('click',function(){
            localStorage.setItem('click-top-inform','click');
            document.querySelector('.blog-top-inform').style.display='none';
          },false)
          wrap.insertBefore(content,wrap.querySelector('script'));
        }
    })();
  </script>
{% endif %}
