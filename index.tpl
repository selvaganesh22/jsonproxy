{% extends 'base.tpl' %}

{% block content %}
    <div id='container'>
      <h2>JSON Proxy</h2>
      <h2>&lt;&#8230;&gt; &#8594; {&#8230;}</h2>
      <p>
        <form action="/proxy" method="GET">
          <input type="text" name="url" />
          <input type="submit" value="Go" />
        </form>
      </p>
      <p>Enter the URL of a publicly accessible XML document.</p>
      <p><a href="/about">Why is this useful?</a> -
      <a href="/examples">Examples</a>
      </p>
      <p class="fine_print">
        powered by <a href="http://code.google.com/appengine/">
        Google App Engine</a>
      </p>
{% comment %}
      <p class="fine_print">
      <a href="/docs">docs</a> -
      <a href="http://code.google.com/p/xml2json">source</a>
      </p>

{% endcomment %}
    </div>
{% endblock %}
