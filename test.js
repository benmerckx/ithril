(function () { "use strict";
var View = function() { };
var Main = function() {
	console.log(this.view());
	m.render(window.document.getElementById("main"),this.view());
};
Main.__interfaces__ = [View];
Main.main = function() {
	new Main();
};
Main.prototype = {
	view: function() {
		var list = [{ title : "Item 1", body : "Body text"},{ title : "Item 2", body : "Body text 2"}];
		return [{ tag : "ul", attrs : { }, children : [(function($this) {
			var $r;
			var _g = [];
			{
				var _g1 = 0;
				while(_g1 < list.length) {
					var item = list[_g1];
					++_g1;
					_g.push([{ tag : "li", attrs : { }, children : []},{ tag : "h1", attrs : { }, children : [item.title,{ tag : "span", attrs : { }, children : ["ok"]}]},{ tag : "p", attrs : { }, children : [item.body]}]);
				}
			}
			$r = _g;
			return $r;
		}(this)),{ tag : "li", attrs : { }, children : ["ok"]}]}];
	}
};
Main.main();
})();
