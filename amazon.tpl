{% extends 'base.tpl' %}

{% block title %}
<title>JSON Proxy Amazon Search Demo</title>
{% endblock %}
{% block script %}
<script src="http://doctype.googlecode.com/svn/trunk/goog/base.js"></script>
<script src="/js/amazon.js"></script>
{% endblock %}

{% block content %}
<h2>JSON Proxy Amazon Search Demo</h2>
<div class="max_width">
  <p>Search Amazon products:<br/>
  <form id='form'>
    <input type=text id="query" value="python"></input><input
      type=submit value="Search"></input>
  </form>
  </p>
  <p>
    <div id="results" style="max-width: 600px;">
      <p>We'll put results here.  Prefilled with "python" since it gives 
        good results.</p>

        <p>This uses the Amazon web service XML interface in combination with
          the JSON Proxy at <a href="http://jsonproxy.appspot.com">
          jsonproxy.appspot.com</a>.  There is no server communication other than
          to the proxy.</p>
    </div>
  </p>
  <script>
    initialize();
  </script>
</div>
{% endblock %}