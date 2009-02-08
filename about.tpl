{% extends 'base.tpl' %}

{% block title%}

{% endblock %}

{% block content %}
<h2>About JSON Proxy</h2>
<div class="max_width">
<p>
Internet Explorer's introduction of
<a href="http://en.wikipedia.org/wiki/XMLHttpRequest"
>XmlHttpRequest</a> allowed for a relatively simple means for web
applications to communicate with the server after page load, spawning
the <a href="http://en.wikipedia.org/wiki/Ajax_(programming)">Ajax</a>
craze.  XMLHttpRequests's <a 
href="http://en.wikipedia.org/wiki/Same_origin_policy">same origin
policy</a> restricts request to the originating site, which prevents 
third-party sites from making cookie-authenticated requests to other
sites and capturing and forwarding private information.  This is a
good thing.</p>

<p>There are, however, legitimate cases in which client-side code would
make a request across domains to XML that is not restricted by
authentication.  If no other means are provided, there is no way to
get at this data with pure JavaScript code.  This is a bad thing.</p>


The problem has prompted the popularity of <a 
href="http://en.wikipedia.org/wiki/JSON#JSONP">JSONP</a> in web APIs,
in which the output is JSON, and a callback parameter may be
specified.  This allows data to be fetched across domains by <a 
href="http://www.xml.com/pub/a/2005/12/21/json-dynamic-script-tag.html">
appending dynamically created script tags</a>.  While servers must be
careful to not serve any non-public information with this method, it
has been adopted as a workable solution.  Many popular API such as 
<a href="http://www.flickr.com/services/api/response.json.html">Flickr</a>
and <a
href="http://apiwiki.twitter.com/Search+API+Documentation#Formats">
Twitter</a> support this format.</p>

<p>Still, this leaves the problem of XML payloads fetchable by GET
that do not offer JSON output.  JSON Proxy exists to provide a
mechanism for client-side JavaScript to access resources at these
locations.  The form at <a href="http://jsonproxy.appspot.com/proxy">
http://jsonproxy.appspot.com/proxy</a> takes GET requests with (at present)
two parameters.  They are:

<p>
<code>
url=&lt;url&gt; The URL to fetch the document from. Required.<br/>
callback=&lt;callback&gt; The callback to call with the resulting JSON
object.  Must be made of these characters: "A-Za-z0-9._". Optional.
</code>
</p>

<p>JSON Proxy will fetch the XML document specified in
<code>url</code> (it may cache up to an hour) and convert that
document to JSON.  At present, it follows, roughly, the conventions at
<a href="http://badgerfish.ning.com/">BadgerFish</a>, with the
exception of namespace handling, which will be added.</p>

<p><img src="/images/jsonproxy.png" alt="JSON Proxy diagram"/></p>

<p>By converting to JSON, the JSON proxy can act as the intermediary
between the third-party server and your browser.  Also, JSON Proxy
will make its requests without cookies, so there's no chance of
accidentally fetching restricted content.</p>

<p>In short, the resulting JSON will be roughly as follows.
<ul>
<li>A single tag will be a direct hash from tag name to a new object:<br/>
<tt>

{% filter escape %}
<foo><bar>...</bar></foo> -> {"foo" : {"bar" : {...}}}
{% endfilter %}

</tt>
<li>Multiple tag will be a direct hash from the tag name to an array:<br/>
<tt>
{% filter escape %}
<foo><bar>...</bar><bar>...</bar></foo> -> {"foo" :
{"bar" : [{...}, {...}]}}
{% endfilter %}
</tt>
<li>Attributes will be prefaced with "@" in the hash:<br/>
<tt>
{% filter escape %}
<foo key="value"></foo> -> { "foo" : {"@key" : "value"}}
{% endfilter %}
</tt>
<li>Text will be under the key "$":<br/>
<tt>
{% filter escape %}
<foo>bar</foo> -> { "foo" : {"$" : "bar"}}
{% endfilter %}
</tt></li>
</ul>

<p>If there is an error of some sort (URL not found, bad XML, etc),
the error string will be at the root of the JSON object under the
special key "$error".  For example: <tt>{"$error": "error string"}</tt></p>

<p>This proxy was written by <a href="http://nanaze.com">Nathan
Naze</a>.  The source is available at <a href="http://code.google.com/p/jsonproxy/">http://code.google.com/p/jsonproxy/</a>.
</p>
</div>
{% endblock %}
