<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; &nbsp; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}
  </span>
  <span class="with-love">
    <i class="icon-next-heart"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}
  </span>
</div>
<div class="powered-by">
<i class="fa fa-user-md"></i><span id="busuanzi_container_site_uv">
  本站总访问量<span id="busuanzi_value_site_uv"></span>次
</span>
</div>
<!--
<div class="powered-by">
  Powered by <a class="theme-link" href="http://hexo.io">Hexo</a>
</div>

<div class="theme-info">
  Theme by <a class="theme-link" href="http://blog.idhyt.com">idhyt</a>.<a class="theme-link" href="https://github.com/idhyt/hexo-theme-next/tree/magiclamp">{{ theme.scheme }}</a>
</div>
-->
<!-- busuanzi -->
{% if (theme.busuanzi) %}
  <div class="">
    {% include '../_scripts/analytics/busuanzi.swig' %}
  </div>
{% endif %}
<div class="theme-info">
  <div class="powered-by"></div>
  <span class="post-count">博客全站共{{ totalcount(site) }}字</span>
</div>
{% block footer %}{% endblock %}
