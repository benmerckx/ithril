(function () { "use strict";
var View = function() { };
var Main = function() {
};
Main.__interfaces__ = [View];
Main.main = function() {
	new Main();
};
Main.prototype = {
	view: function() {
		null;
	}
};
Main.main();
})();
