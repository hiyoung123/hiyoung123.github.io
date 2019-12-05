{% extends '_layout.swig' %}
{% import '_macro/sidebar.swig' as sidebar_template with context %}

  {% block title %}
    {%- set page_title_suffix = ' | ' + title %}

    {%- if page.type === 'categories' %}
      {{- __('title.category') + page_title_suffix }}
    {%- elif page.type === 'coding' %}
      {{- __('title.coding') + page_title_suffix }}
    {%- elif page.type === 'tags' %}
      {{- __('title.tag') + page_title_suffix }}
    {%- elif page.type === 'about' %}
      {{- __('title.about') + page_title_suffix }}
    {%- elif page.type === 'schedule' and not page.title %}
      {{- __('title.schedule') + page_title_suffix }}
    {%- else %}
      {{- page.title + page_title_suffix }}
    {%- endif %}
  {% endblock %}

{% block content %}

  <div class="posts-expand">
    {##################}
    {### PAGE BLOCK ###}
    {##################}
    <div class="post-block" lang="{{ page.lang or page.language or config.language }}">
      {%- if page.type === 'about' %}
      <div class="post-meta">
      <{%- if theme.seo %}h2{% else %}h1{%- endif %} class="post-title" itemprop="name headline">
      About me
      </{%- if theme.seo %}h2{% else %}h1{%- endif %}>
      {{ partial('_partials/social-link.swig', {}, {cache: theme.cache.enable}) }}
      </div>
      {%- endif %}
      {#################}
      {### PAGE BODY ###}
      {#################}

        {%- if page.type === 'tags' %}
          <div class="tag-cloud">
            <div class="tag-cloud-title">
              {{ _p('counter.tag_cloud', site.tags.length) }}
            </div>
            <div class="tag-cloud-tags">
              {{ tagcloud({min_font: theme.tagcloud.min, max_font: theme.tagcloud.max, amount: theme.tagcloud.amount, color: true, start_color: theme.tagcloud.start, end_color: theme.tagcloud.end}) }}
            </div>
          </div>
        {% elif page.type === 'categories' %}
          <div class="category-all-page">
            <div class="category-all-title">
              {{ _p('counter.categories', site.categories.length) }}
            </div>
            <div class="category-all">
              {{ list_categories() }}
            </div>
          </div>
        {% elif page.type === 'schedule' %}
          <div class="event-list">
          </div>
          {% include '_scripts/pages/schedule.swig' %}
        {% elif page.type === 'about' %}
          {{ page.content }}
        {% elif page.type === 'coding' %}
          {{ page.content }}
        {% else %}
          {{ page.content }}
        {%- endif %}

      {#####################}
      {### END PAGE BODY ###}
      {#####################}
    </div>
    {% include '_partials/page/breadcrumb.swig' %}
    {######################}
    {### END PAGE BLOCK ###}
    {######################}
  </div>

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(true) }}
{% endblock %}
