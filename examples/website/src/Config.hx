import ithril.*;
import ithril.M.*;
import util.From;
using Reflect;

class Config {
	static public function setup() {
		// parse configuration file
		var config:Dynamic = {};
#if !browser
		var args = Sys.args();
		var help = function help(msg) { Sys.println(msg); Sys.exit(0); }
		var argHandler = util.Args.generate([
			@doc("Configuration file") ["-c", "--config"] => function(configFilename:String) config = haxe.Json.parse(sys.io.File.getContent(configFilename)),
			@doc("Path to render") ["-p", "--path"] => function(path:String) config.path = path,
			_ => function(arg:String) help('Error: $arg\n')
		]);
		if (args.length < 2) help('Missing arguments\n' + argHandler.getDoc()); else argHandler.parse(args);
#end
		// setup page routes
		config.routes = { };
		var setRoute = function setRoute(key:String, value:Dynamic) config.routes.setField(key, { render: value });
		Attributes.combine(initial(config), config);
		for (href in config.pages.fields()) {
			var view = m(Website, pageAttributes(href, config));
			setRoute(href, function (vnode) return view);
		}

		return config;
	}

	// calculate attributes specific to a route
	static inline function pageAttributes(href:String, state:Dynamic)
		return Attributes.combine(Attributes.combine(state.pages.field(href), state), { href: href });

	// initial configuration
	static inline function initial(config) {
		return {
#if (!browser)

			// embed javascript directly in page
			script: !config.html.javascript ? [] :
				[
	#if compress
				#if uglifyjs
					{ content: From.command('uglifyjs', [ '--compress', '--mangle', '--', 
						'node_modules/mithril/mithril.min.js', 
						'node_modules/mithril/stream/stream.js',
						'obj/browser.js', ]), 
					  type: "text/javascript" },
				#else
					{ content: From.file('node_modules/mithril/mithril.min.js'), 
					  attributes: { type: "text/javascript" } },
					{ content: From.file('node_modules/mithril/stream/stream.js'), 
					  attributes: { type: "text/javascript" } },
					{ content: From.command('closure-compiler', [ '-O', 'SIMPLE', 'obj/browser.js', ]), 
					  attributes: { type: "text/javascript" } },
				#end
	#else
					{ content: From.file('node_modules/mithril/mithril.js'), 
					  attributes: { type: "text/javascript" } },
					{ content: From.file('node_modules/mithril/stream/stream.js'), 
					  attributes: { type: "text/javascript" } },
					{ content: From.file('obj/browser.js'), 
					  attributes: { type: "text/javascript" } },
	#end
				],

			// embed css directly in page
			css: !config.html.css ? [] :
				[
	#if compress
					{ content: From.command('sass', [ 'include/css/style.scss', '--style', 'compressed', ]), 
					  attributes: { type: "text/css" } },
	#else
					{ content: From.command('sass', [ 'include/css/style.scss', '--style', 'compact', ]), 
					  attributes: { type: "text/css" } },
	#end
				],

			// meta tags
			meta: ([
					{ charset: config.html.charset },
					{ name: "viewport", content: "width=device-width, initial-scale=1.0" }
			]:Array<Dynamic>),

			// link tags
			link: ([
				{ rel: "icon", type: "image/x-icon", href: "data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA/7VrAP8AJgD///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAEQARAAEAEQERABEQEQARERERERERABEREREREREAEREREREREQARERERERERABERMxERMxEAERMyIRMyIQABEzIhEzIgAAETMzETMzAAAREzEREzEAAAEREREREAAAABEREREAAAAAABERAAAAAAAAAAAAAAD//wAAuZ0AAJGJAACAAQAAgAEAAIABAACAAQAAgAEAAIABAADAAwAAwAMAAMADAADgBwAA8A8AAPw/AAD//wAA" }
			]),

#end
			// site branding
			brand: 'Home',
			brandPage: '/',

			// site pages
			pages: {

				"/": {
					component: "HomePage",
					title: "Home",
					homeHeader: "Home",
					homeText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc.",
					content: [
						{ header: 'Home-A', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
						{ header: 'Home-B', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
						{ header: 'Home-C', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
					]},

				"/page1.html": {
					component: "ContentPage",
					title: "Page One",
					nav: "one",
					content: [
						{ header: 'Page One', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
					]},

				"/page2.html": {
					component: "ContentPage",
					title: "Page Two",
					nav: "two",
					content: [
						{ header: 'Page Two', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
					]},

				"/page3.html": {
					component: "ContentPage",
					title: "Page Three",
					nav: "three",
					content: [
						{ header: 'Page Three-A', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
						{ header: 'Page Three-B', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
						{ header: 'Page Three-C', text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et efficitur diam, feugiat lobortis nunc." },
					]},
			},

			// mithril-stream for input element
			streamVal: #if browser new Stream("") #else null #end,
		};
	}
}
