{# Reset `window.Promise` when it was not a function. #}
{# IE refers the element whose id is `Promise` as `window.Promise`, this causes Velocity throwing an exception #}

{% if theme.blog_migration_new_url %}
  <script type="text/javascript">
    (function() {
        // var oldUrl = window.location.href;
        // if(/https{0,1}\:\/\/(guowenfh.github.io|guowenfh.com)/i.test(oldUrl)){
        //  window.location.href = oldUrl.replace(/https{0,1}\:\/\/(guowenfh.github.io|guowenfh.com)/i,'//blog.guowenfh.com');
        //}
        // if( /blog.guowenfh.com/i.test(window.location.href)  && localStorage.getItem('click-top-inform')!=='click'){
        //   var wrap = document.body;
        //   var content = document.createElement('div');
        //   content.innerHTML= '为了方便管理，本博客已购买该域名，访问原站，将自动跳转至该新地址。（点击此处删除该提示）';
        //   content.style.textAlign = 'center';
        //   content.style.color = 'red';
        //   content.style.position = 'relative';
        //   content.style.padding = '10px 20px';
        //   content.className = "blog-top-inform";
        //   content.addEventListener('click',function(){
        //     localStorage.setItem('click-top-inform','click');
        //     document.querySelector('.blog-top-inform').style.display='none';
        //   },false)
        //   wrap.insertBefore(content,wrap.querySelector('script'));
        // }
    })();
  </script>
{% endif %}

<script type="text/javascript">
  if (Object.prototype.toString.call(window.Promise) !== '[object Function]') {
    window.Promise = null;
  }
</script>

{% set js_vendors = {} %}
{% set js_vendors.jquery      = 'jquery/index.js?v=2.1.3' %}
{% set js_vendors.fastclick   = 'fastclick/lib/fastclick.min.js?v=1.0.6' %}
{% set js_vendors.lazyload    = 'jquery_lazyload/jquery.lazyload.js?v=1.9.7' %}
{% set js_vendors.velocity    = 'velocity/velocity.min.js?v=1.2.1' %}
{% set js_vendors.velocity_ui = 'velocity/velocity.ui.min.js?v=1.2.1' %}

{% if theme.fancybox %}
  {% set js_vendors.fancybox  = 'fancybox/source/jquery.fancybox.pack.js?v=2.1.5' %}
{% endif %}
{% if theme.canvas_nest %}
  {% set js_vendors.canvas_nest  = 'canvas-nest/canvas-nest.min.js' %}
{% endif %}

{% if theme.three_waves %}
  {% set js_vendors.three  = 'three/three.min.js' %}
  {% set js_vendors.three_waves  = 'three/three-waves.min.js' %}
{% endif %}

{% if theme.canvas_lines %}
  {% set js_vendors.three  = 'three/three.min.js' %}
  {% set js_vendors.canvas_lines  = 'three/canvas_lines.min.js' %}
{% endif %}

{% if theme.canvas_sphere %}
  {% set js_vendors.three  = 'three/three.min.js' %}
  {% set js_vendors.canvas_sphere  = 'three/canvas_sphere.min.js' %}
{% endif %}

{% if theme.canvas_ribbon and theme.scheme === 'Pisces'%}
  {% set js_vendors.canvas_ribbon  = 'canvas-ribbon/canvas-ribbon.js' %}
{% endif %}

{% for name, internal in js_vendors %}
  {% set internal_script = url_for(theme.vendors._internal) + '/' + internal %}
  <script type="text/javascript" src="{{ theme.vendors[name] | default(internal_script) }}"></script>
{% endfor %}
