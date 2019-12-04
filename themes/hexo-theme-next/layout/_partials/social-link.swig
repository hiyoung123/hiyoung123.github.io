{%- if (theme.social.GitHub) %}
    <a href="{{ theme.social.GitHub.split("||")[0] }}" class="tooltipped" target="_blank" data-tooltip="访问我的GitHub" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-github"></i>
    </a>
{%- endif %}

{%- if (theme.social.Email) %}
    <a href="mailto:{{ theme.social.Email.split("||")[0] }}" class="tooltipped" target="_blank" data-tooltip="邮件联系我" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-envelope"></i>
    </a>
{%- endif %}

{%- if (theme.social.facebook) %}
    <a href="{{ theme.social.facebook.split("||")[0] }}" class="tooltipped" target="_blank" data-tooltip="关注我的Facebook: {{ theme.social.facebook.split("||")[0] }}" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-facebook-f"></i>
    </a>
{%- endif %}

{%- if (theme.social.twitter) %}
    <a href="{{ theme.social.twitter.split("||")[0] }}" class="tooltipped" target="_blank" data-tooltip="关注我的Twitter: {{ theme.social.twitter.split("||")[0] }}" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-twitter"></i>
    </a>
{%- endif %}

{%- if (theme.social.QQ) %}
    <a href="tencent://AddContact/?fromId=50&fromSubId=1&subcmd=all&uin={{ theme.social.QQ.split("||")[0] }}" class="tooltipped" target="_blank" data-tooltip="QQ联系我: {{ theme.social.QQ.split("||")[0] }}" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-qq"></i>
    </a>
{%- endif %}

{%- if (theme.social.weibo) %}
    <a href="{{ theme.social.weibo.split("||")[0] }}" class="tooltipped" target="_blank" data-tooltip="关注我的微博: {{ theme.social.weibo.split("||")[0] }}" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-weibo"></i>
    </a>
{%- endif %}

{%- if (theme.social.zhihu) %}
    <a href="{{ theme.social.zhihu.split("||")[0] }}" class="tooltipped" target="_blank" data-tooltip="关注我的知乎: {{ theme.social.zhihu.split("||")[0] }}" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-zhihu1">知</i>
    </a>
{%- endif %}

{%- if (theme.social.RSS) %}
    <a href="{{ url_for('/atom.xml') }}" class="tooltipped" target="_blank" data-tooltip="RSS 订阅" data-position="top" data-delay="50">
        <i class="fa fa-fw fa-rss"></i>
    </a>
{%- endif %}
