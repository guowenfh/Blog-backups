{% if theme.blog_migration_new_url %}
  <script type="text/javascript">
    (function() {
        var oldUrl = window.location.href;
        if(/guowenfh.github.io/i.test(oldUrl)){
          window.location.href = oldUrl.replace(/guowenfh.github.io/i,'blog.guowenfh.com');
        }
        if( /blog.guowenfh.com/i.test(window.location.href)  && localStorage.getItem('click-top-inform')!=='click'){
          var wrap = document.querySelector('body');
          var content = document.createElement('div');
          content.innerHTML= '为了方便管理，本博客已购买域名，访问原站，将自动跳转至该新地址。（该提示点击删除）';
          content.style.textAlign='center';
          content.style.position = 'relative';
          content.style.padding = '10px 20px';
          content.className="blog-top-inform";
          content.addEventListener('click',function(){
            localStorage.setItem('click-top-inform','click');
            document.querySelector('.blog-top-inform').style.display='none';
          },false)
          wrap.insertBefore(content,document.querySelector('.container'));
        }
    })();
  </script>
{% endif %}
