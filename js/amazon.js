// TODO(nathan): Code lacks documentation, comments, cleanliness, classes,
// namespacing, and clarity.

goog.require('goog.Uri');
goog.require('goog.array');
goog.require('goog.dom');
goog.require('goog.events');
goog.require('goog.string');

function initialize() {
  var form = document.getElementById('form');
  goog.events.listen(form, 'submit', handleSubmit);
};

var AMAZON_URL = 'http://ecs.amazonaws.com/onca/xml'
var PROXY_URL = 'http://jsonproxy.appspot.com/proxy';

function amazonCall(operation, parameters, callback) {
  var amazonUri = new goog.Uri(AMAZON_URL);
  setParameterMap(amazonUri, {
    'Service': 'AWSECommerceService',
        'AWSAccessKeyId' : '1VQB5H9VRKBMGBPBGP82'});

  setParameterMap(amazonUri, parameters);
  amazonUri.setParameterValue('Operation', 'ItemSearch');

  var uri = new goog.Uri(PROXY_URL);
  uri.setParameterValue('url', amazonUri.toString());
  fetchJsonObject(uri, callback);
}

function setParameterMap(uri, map) {
  goog.object.forEach(map, function (value, key) {
    uri.setParameterValue(key, value);
  });
}


function handleSubmit(e) {
  e.preventDefault();

  var query = document.getElementById('query').value;

  amazonCall('ItemSearch', {
    'SearchIndex': 'Blended',
   'Keywords': query}, handleSearchJsonObj);
};

function handleSearchJsonObj(obj) {

  var resultsDiv = goog.dom.$('results');
  resultsDiv.innerHTML = '';
  var items = goog.isArray(obj.Items.Item) ? obj.Items.Item : [obj.Items.Item];

  goog.array.forEach(items, function(item) {
    var asin = item.ASIN['$'];
    var url = item.DetailPageURL.$;
    var title = '';
    if (item.ItemAttributes.Title) {
      title = item.ItemAttributes.Title.$;
    }

    var a = goog.dom.createElement('a');
    a.href = url;

    goog.dom.appendChild(resultsDiv, a);

    var img = goog.dom.createElement('img');
    var src = goog.string.subs(
        'http://images.amazon.com/images/P/%s.01.jpg', asin);
    img.src = src;
    img.border = 0;
    img.title = title;
    img.style.padding = '2px';

    goog.dom.appendChild(a, img);
  });
}


var callbacks = {};
var callbackCounter = 0;

function fetchJsonObject(uri, callback) {

  var counterId = callbackCounter++;

  callbacks[counterId] = callback;

  uri.setParameterValue(
      'callback', 
      'callbacks[' + counterId + ']');

  appendTag(uri.toString());
};

function appendTag(url) {
  var script = goog.dom.createElement('script');
  var head = document.getElementsByTagName('head')[0];
  script.src = url;
  goog.dom.appendChild(head, script);    
};
