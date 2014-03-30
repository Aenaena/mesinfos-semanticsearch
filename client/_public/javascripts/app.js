(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  var list = function() {
    var result = [];
    for (var item in modules) {
      if (has(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.list = list;
  globals.require.brunch = true;
})();
require.register("application", function(exports, require, module) {
var Router, SearchView, app;

Router = require('./router');

SearchView = require('./views/search');

module.exports = app = {
  initialize: function() {
    window.app = this;
    Date.setLocale('fr');
    Router = require('router');
    this.router = new Router();
    this.header = new SearchView().render();
    $('body').empty().append(this.header.$el);
    return Backbone.history.start();
  }
};

$(function() {
  return app.initialize();
});

});

;require.register("collections/search_results", function(exports, require, module) {
var BaseModel, DateModel, SearchCollection, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseModel = require('../models/base');

DateModel = require('../models/date');

module.exports = SearchCollection = (function(_super) {
  __extends(SearchCollection, _super);

  function SearchCollection() {
    _ref = SearchCollection.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  SearchCollection.prototype.model = BaseModel;

  SearchCollection.prototype.initialize = function(items, options) {
    if (options.query) {
      return this.fetch({
        url: "semantic/nlp?query=" + encodeURIComponent(options.query)
      });
    }
  };

  SearchCollection.prototype.parse = function(data) {
    var date, dict, hour, id, links, match, model, models, node, token, _i, _len, _ref1, _ref2;

    models = [];
    links = [];
    _ref1 = data.semantic;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      match = _ref1[_i];
      dict = {};
      for (token in match) {
        node = match[token];
        if (node.token === 'uri') {
          id = node.value.replace('https://my.cozy.io/', '');
          if (id.substr(0, 8) === 'instant/') {
            _ref2 = id.substr(8).split('T'), date = _ref2[0], hour = _ref2[1];
            hour = hour.replace(/-/g, ':');
            models.push(model = new DateModel(date + 'T' + hour));
            dict[token] = model.cid;
          } else {
            models.push(model = new BaseModel(data.docs[id]));
            dict[token] = model.cid;
          }
        }
      }
      links = links.concat(data.links.map(function(l) {
        return {
          s: dict[l.s],
          o: dict[l.o]
        };
      }));
    }
    this.links = links;
    return models;
  };

  return SearchCollection;

})(Backbone.Collection);

});

;require.register("lib/base_view", function(exports, require, module) {
var BaseView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BaseView = (function(_super) {
  __extends(BaseView, _super);

  function BaseView() {
    _ref = BaseView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BaseView.prototype.template = function() {};

  BaseView.prototype.initialize = function() {};

  BaseView.prototype.getRenderData = function() {
    var _ref1;

    return {
      model: (_ref1 = this.model) != null ? _ref1.toJSON() : void 0
    };
  };

  BaseView.prototype.render = function() {
    this.beforeRender();
    this.$el.html(this.template(this.getRenderData()));
    this.afterRender();
    return this;
  };

  BaseView.prototype.beforeRender = function() {};

  BaseView.prototype.afterRender = function() {};

  BaseView.prototype.destroy = function() {
    this.undelegateEvents();
    this.$el.removeData().unbind();
    this.remove();
    return Backbone.View.prototype.remove.call(this);
  };

  return BaseView;

})(Backbone.View);

});

;require.register("lib/view_collection", function(exports, require, module) {
var BaseView, ViewCollection, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require('lib/base_view');

module.exports = ViewCollection = (function(_super) {
  __extends(ViewCollection, _super);

  function ViewCollection() {
    this.removeItem = __bind(this.removeItem, this);
    this.addItem = __bind(this.addItem, this);    _ref = ViewCollection.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ViewCollection.prototype.itemview = null;

  ViewCollection.prototype.views = {};

  ViewCollection.prototype.template = function() {
    return '';
  };

  ViewCollection.prototype.itemViewOptions = function() {};

  ViewCollection.prototype.collectionEl = null;

  ViewCollection.prototype.onChange = function() {
    return this.$el.toggleClass('empty', _.size(this.views) === 0);
  };

  ViewCollection.prototype.appendView = function(view) {
    return this.$collectionEl.append(view.el);
  };

  ViewCollection.prototype.initialize = function() {
    ViewCollection.__super__.initialize.apply(this, arguments);
    this.views = {};
    this.listenTo(this.collection, "reset", this.onReset);
    this.listenTo(this.collection, "add", this.addItem);
    this.listenTo(this.collection, "remove", this.removeItem);
    if (this.collectionEl == null) {
      this.collectionEl = this.el;
      return this.$collectionEl = this.$el;
    }
  };

  ViewCollection.prototype.render = function() {
    var id, view, _ref1;

    _ref1 = this.views;
    for (id in _ref1) {
      view = _ref1[id];
      view.$el.detach();
    }
    return ViewCollection.__super__.render.apply(this, arguments);
  };

  ViewCollection.prototype.afterRender = function() {
    var id, view, _ref1;

    if (!this.$collectionEl) {
      this.$collectionEl = this.$(this.collectionEl);
    }
    _ref1 = this.views;
    for (id in _ref1) {
      view = _ref1[id];
      this.appendView(view);
    }
    this.onReset(this.collection);
    return this.onChange(this.views);
  };

  ViewCollection.prototype.remove = function() {
    this.onReset([]);
    return ViewCollection.__super__.remove.apply(this, arguments);
  };

  ViewCollection.prototype.onReset = function(newcollection) {
    var id, view, _ref1;

    _ref1 = this.views;
    for (id in _ref1) {
      view = _ref1[id];
      view.remove();
    }
    return newcollection.forEach(this.addItem);
  };

  ViewCollection.prototype.addItem = function(model) {
    var options, view;

    options = _.extend({}, {
      model: model
    }, this.itemViewOptions(model));
    view = new this.itemview(options);
    this.views[model.cid] = view.render();
    this.appendView(view);
    return this.onChange(this.views);
  };

  ViewCollection.prototype.removeItem = function(model) {
    this.views[model.cid].remove();
    delete this.views[model.cid];
    return this.onChange(this.views);
  };

  return ViewCollection;

})(BaseView);

});

;require.register("models/base", function(exports, require, module) {
var BaseModel, formatDuration, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BaseModel = (function(_super) {
  __extends(BaseModel, _super);

  function BaseModel() {
    _ref = BaseModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BaseModel.prototype.getSummary = function() {
    var date, direction, image, _ref1;

    console.log(this.attributes);
    switch (this.get('docType').toLowerCase()) {
      case 'contact':
        image = ((_ref1 = this.get('_attachments')) != null ? _ref1.picture : void 0) ? "images/contact/" + (this.get('_id')) + "/picture" : 'img/contact.png';
        return {
          title: this.get('fn'),
          image: image
        };
      case 'phonecommunicationlog':
        date = Date.create(this.get('timestamp'));
        direction = this.get('direction') === 'OUTGOING' ? 'sortant' : 'entrant';
        return {
          title: 'Appel ' + direction,
          image: 'img/phonecalllog.png',
          content: formatDuration(this.get('chipCount'))
        };
    }
  };

  return BaseModel;

})(Backbone.Model);

formatDuration = function(seconds) {
  var h, m, out, s;

  seconds = parseInt(seconds);
  s = seconds % 60;
  m = ((seconds - s) % 3600) / 60;
  h = (seconds - s - m * 60) / 3600;
  out = s + 's';
  if (m) {
    out = m + 'min ' + out;
  }
  if (h) {
    out = h + 'h ' + out;
  }
  return out;
};

});

;require.register("models/date", function(exports, require, module) {
var DateModel,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = DateModel = (function(_super) {
  __extends(DateModel, _super);

  function DateModel(value) {
    DateModel.__super__.constructor.call(this, {
      value: new Date(value)
    });
  }

  DateModel.prototype.getSummary = function() {
    return {
      title: this.get('value').format('short'),
      image: 'img/date.png',
      content: this.get('value').format('{HH}:{mm}')
    };
  };

  return DateModel;

})(Backbone.Model);

});

;require.register("router", function(exports, require, module) {
var HomeView, Router, SearchResultView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HomeView = require('./views/home');

SearchResultView = require('./views/search_results');

module.exports = Router = (function(_super) {
  __extends(Router, _super);

  function Router() {
    _ref = Router.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Router.prototype.routes = {
    '': 'home',
    'search/*query': 'query'
  };

  Router.prototype.home = function() {
    app.header.setContent("");
    return this.displayView(new HomeView());
  };

  Router.prototype.query = function(search) {
    app.header.setContent(decodeURIComponent(search));
    return this.displayView(new SearchResultView({
      query: search
    }));
  };

  Router.prototype.displayView = function(view) {
    if (this.mainView) {
      this.mainView.remove();
    }
    $('body').append(view.$el);
    return this.mainView = view.render();
  };

  return Router;

})(Backbone.Router);

});

;require.register("templates/card", function(exports, require, module) {
module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
buf.push('<div class="caption media"><img');
buf.push(attrs({ 'src':(image), "class": ('media-object') + ' ' + ('pull-left') }, {"src":true}));
buf.push('/><h3 class="media-body">');
var __val__ = title
buf.push(escape(null == __val__ ? "" : __val__));
buf.push('</h3>');
if ( content)
{
buf.push('<p class="clearfix">');
var __val__ = content
buf.push(null == __val__ ? "" : __val__);
buf.push('</p>');
}
buf.push('</div>');
}
return buf.join("");
};
});

;require.register("templates/home", function(exports, require, module) {
module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
buf.push('<h1>Bienvenue sur L\'application SemSearch.</h1><p class="status">Veuillez patientez quelques instants.\nL\'analyseur est en train de lier vos données.</p><h2>Examples de requêtes</h2><ul class="samples">');
 text = "Qui ai-je appele en mars ?"
buf.push('<li><a');
buf.push(attrs({ 'href':("#search/" + encodeURIComponent(text)) }, {"href":true}));
buf.push('>');
var __val__ = '"' + text + '"'
buf.push(escape(null == __val__ ? "" : __val__));
buf.push('</a></li>');
 text = "Quand ai-je reçu un virement de Germaine ?"
buf.push('<li><a');
buf.push(attrs({ 'href':("#search/" + encodeURIComponent(text)) }, {"href":true}));
buf.push('>');
var __val__ = '"' + text + '"'
buf.push(escape(null == __val__ ? "" : __val__));
buf.push('</a></li></ul>');
}
return buf.join("");
};
});

;require.register("templates/search", function(exports, require, module) {
module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
buf.push('<div class="container"><div class="navbar-header"><button type="button" data-toggle="collapse" data-target=".navbar-collapse" class="navbar-toggle"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button><a href="#" class="navbar-brand">SemSearch</a></div><div class="navbar-collapse collapse"><form role="search" ng-controller="SearchCtrl" class="navbar-form navbar-left"><input type="text" placeholder="Rechercher" class="input-large form-control"/></form></div></div>');
}
return buf.join("");
};
});

;require.register("views/card", function(exports, require, module) {
var BaseView, CardView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require('../lib/base_view');

module.exports = CardView = (function(_super) {
  __extends(CardView, _super);

  function CardView() {
    _ref = CardView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CardView.prototype.tagName = 'a';

  CardView.prototype.className = 'card';

  CardView.prototype.template = require('../templates/card');

  CardView.prototype.events = {
    'click ': 'toggleSelected'
  };

  CardView.prototype.getRenderData = function() {
    return _.extend({
      title: '',
      content: ''
    }, this.model.getSummary());
  };

  CardView.prototype.toggleSelected = function(event) {
    this.$el.toggleClass('selected');
    if (this.$el.hasClass('selected')) {
      return this.$el.append($('<div class="more">').text('Plus d\'info').slideDown());
    } else {
      return this.$('.more').slideUp(function() {
        return this.$('.more').remove();
      });
    }
  };

  CardView.prototype.centerPos = function() {
    var left, top, _ref1;

    _ref1 = this.$el.position(), left = _ref1.left, top = _ref1.top;
    left += this.$el.width() / 2;
    top += this.$el.height() / 2;
    return {
      left: left,
      top: top
    };
  };

  return CardView;

})(BaseView);

});

;require.register("views/home", function(exports, require, module) {
var BaseView, HomeView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require('../lib/base_view');

module.exports = HomeView = (function(_super) {
  __extends(HomeView, _super);

  function HomeView() {
    _ref = HomeView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  HomeView.prototype.className = 'jumbotron';

  HomeView.prototype.template = require('../templates/home');

  return HomeView;

})(BaseView);

});

;require.register("views/search", function(exports, require, module) {
var BaseView, FolderView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require('../lib/base_view');

module.exports = FolderView = (function(_super) {
  __extends(FolderView, _super);

  function FolderView() {
    _ref = FolderView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  FolderView.prototype.className = 'navbar navbar-inverse navbar-fixed-top';

  FolderView.prototype.template = require('../templates/search');

  FolderView.prototype.events = {
    'keydown input': 'onKeyDown'
  };

  FolderView.prototype.setContent = function(text) {
    return this.$('input').val(text);
  };

  FolderView.prototype.onKeyDown = function(event) {
    var url;

    if (event.which === 13) {
      url = "search/" + encodeURIComponent(this.$('input').val());
      return app.router.navigate(url, {
        trigger: true
      });
    }
  };

  return FolderView;

})(BaseView);

});

;require.register("views/search_results", function(exports, require, module) {
var SearchCollection, SearchResults, ViewCollection, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ViewCollection = require('../lib/view_collection');

SearchCollection = require('../collections/search_results');

module.exports = SearchResults = (function(_super) {
  __extends(SearchResults, _super);

  function SearchResults() {
    _ref = SearchResults.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  SearchResults.prototype.id = 'result-view';

  SearchResults.prototype.className = 'container-fluid';

  SearchResults.prototype.counter = 0;

  SearchResults.prototype.itemview = require('./card');

  SearchResults.prototype.initialize = function(options) {
    this.collection = new SearchCollection([], options);
    this.lines = this.createSVG('svg', {});
    return SearchResults.__super__.initialize.apply(this, arguments);
  };

  SearchResults.prototype.createSVG = function(tagName, attr) {
    var elem;

    elem = window.document.createElementNS('http://www.w3.org/2000/svg', tagName);
    return $(elem).attr(attr);
  };

  SearchResults.prototype.appendView = function(view) {
    var _this = this;

    view.$el.css({
      top: 50 + 10 * this.counter++,
      left: 350 * this.counter
    });
    SearchResults.__super__.appendView.apply(this, arguments);
    return this.collection.links.filter(function(l) {
      var _ref1;

      return (_ref1 = view.model.cid) === l.s || _ref1 === l.o;
    }).map(function(l) {
      if (l.s === view.model.cid) {
        return l.o;
      } else {
        return l.s;
      }
    }).forEach(function(cid) {
      var a, b;

      if (!_this.views[cid]) {
        return;
      }
      a = _this.views[cid].centerPos();
      b = view.centerPos();
      return _this.lines.append(_this.createSVG('line', {
        x1: a.left,
        y1: a.top,
        x2: b.left,
        y2: b.top,
        style: 'stroke:#ddd;stroke-width:2;'
      }));
    });
  };

  SearchResults.prototype.afterRender = function() {
    SearchResults.__super__.afterRender.apply(this, arguments);
    this.$el.height($('body').height());
    return this.$el.append(this.lines.attr({
      width: this.$el.width(),
      height: this.$el.height()
    }));
  };

  return SearchResults;

})(ViewCollection);

});

;
//@ sourceMappingURL=app.js.map