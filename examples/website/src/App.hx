import ithril.*;
import ithril.M.*;
import util.From;
using Reflect;

class App {
	static var config = Config.setup();

#if browser
	// configure route prefix and notify mithril to start routing
	public static function main() {
		routePrefix("");
		route(js.Browser.document.body, "/", config.routes);
	}

#elseif webserver
	// configure a node+express webserver and start listening for requests
	static public function main() {
		var srv = new js.npm.Express();
		if (config.listen.compression) srv.use(new js.npm.express.Compression());
		if (config.listen.httpLogFormat != null) srv.use(new js.npm.express.Morgan(config.listen.httpLogFormat));
		srv.get('/favicon.ico', function (req, res:Dynamic) res.status(404).end());
		if (config.html.render) srv.get("*", function (req, res, next) render(config, req, res, next));
		srv.use('/', new js.npm.express.Static(config.html.path));
		srv.use(function(req, res:Dynamic) res.status(404).end());
		var http = cast js.node.Http.createServer().on('request', cast srv);
		http.listen(config.listen);
	}

#elseif renderview
	// render html to stdout
	static public function main()
		render(config, { path: config.path }, { send: Sys.println, status: Sys.println }, function () throw 'missing path: ${config.path}');

#end

#if !browser
	// try to render a request
	public static function render(config:Dynamic, request:Dynamic, response:Dynamic, ?next:Dynamic) {
		var route = config.routes.field(request.path);
		if (route == null || route.render == null) {
			if (next == null)
				response.status(500).end();
			else
				next();
		}
		else
			HTMLRenderer.render(route.render())
				.then(function(rslt) { response.send(rslt); },
					  function(err) { Sys.println('ERR: $err'); response.status(500).end(); });
	}
#end
}
