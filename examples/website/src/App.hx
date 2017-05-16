import ithril.*;
import ithril.M.*;
using Reflect;
// Main application entry point
class App {
	public static var config:Dynamic = Config.load();
#if browser
	static function main() View.execute();
#elseif webserver
	static function main() WebServer.execute();
#elseif renderview
	static function main() View.render({ path: App.config.path }, { send: Sys.println, status: Sys.println });
#end
}

// Application configuration
class Config {
	static public function load() {
		App.config = {};
#if !browser
		var args = Sys.args();
		var help = function help(msg) { Sys.println(msg); Sys.exit(0); }
		var argHandler = util.Args.generate([
			@doc("Configuration file") ["-c", "--config"] => function(config:String) App.config = haxe.Json.parse(sys.io.File.getContent(config)),
			@doc("Path to render") ["-p", "--path"] => function(path:String) App.config.path = path,
			_ => function(arg:String) help('Error: $arg\n')
		]);
		if (args.length < 2) help('Missing arguments\n' + argHandler.getDoc()); else argHandler.parse(args);
#end
		App.config.routes = { };
		for (href in State.current.pages.fields()) App.config.routes.setField(href, { render: Website.view(href) });
		return App.config;
	}
}

// Execute and render views
class View {
	public static function execute() {
		routePrefix("");
		route(js.Browser.document.body, "/", App.config.routes);
	}

#if !browser
	public static function render(request, response:Dynamic)
		HTMLRenderer.render(App.config.routes.field(request.path).render())
			.then(function(rslt) { response.send(rslt); },
				  function(err) { Sys.println('ERR: $err'); response.status(500).end(); });
#end
}

// A node+express webserver
#if (webserver && nodejs)
class WebServer {
	static public function execute() {
		var srv = new js.npm.Express();
		if (App.config.listen.compression) srv.use(new js.npm.express.Compression());
		if (App.config.listen.httpLogFormat != null) srv.use(new js.npm.express.Morgan(App.config.listen.httpLogFormat));
		srv.get('/favicon.ico', function (req, res:Dynamic) res.status(404).end());
		if (App.config.html.render)
			srv.get("*", View.render);
		else
			srv.use('/', new js.npm.express.Static(App.config.html.path));
		srv.use(function(req, res:Dynamic) res.status(404).end());
		var http = cast js.node.Http.createServer().on('request', cast srv);
		http.listen(App.config.listen);
	}
}
#end
