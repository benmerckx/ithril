(function () { "use strict";
var Main = function() {
	this.view();
};
Main.main = function() {
	new Main();
};
Main.prototype = {
	view: function() {
		null;
	}
};
var TestMacro = function() { };
var mithril = {};
mithril.Model = function() { };
mithril.View = function() { };
mithril.ControllerView = function() { };
mithril.Controller = function() { };
mithril.Module = function() { };
try {
(function(m) {
			m.m =          m;
			m.__module   = m.module;
			m.__currMod  = null;
			m.module = function(root, module) { m.__currMod = module; return m.__module(root, module); }
			if (typeof module !== 'undefined' && module.exports) 
				m.request = function(xhrOptions) { return m.deferred().promise; };
		})(window.m);
} catch(_) {}
try {
GLOBAL.m = require("mithril");
var __varName = GLOBAL.m;
(function(m) {
			m.m =          m;
			m.__module   = m.module;
			m.__currMod  = null;
			m.module = function(root, module) { m.__currMod = module; return m.__module(root, module); }
			if (typeof module !== 'undefined' && module.exports) 
				m.request = function(xhrOptions) { return m.deferred().promise; };
		})(__varName);
} catch(_) {}
Main.main();
})();
