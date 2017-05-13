import ithril.*;
using Reflect;
// Application state
class State {
	static public function page(href:String)
		return Attributes.combine(Attributes.combine(State.current.pages.field(href), State.current), { href: href });

	static public var current(get, null):Dynamic;
	static function get_current() {
		if (current == null) {
			current = {
#if !browser
				javascript: App.config.html.javascript ? Resources.javascript : [],
				css: App.config.html.css ? Resources.css : [],
				meta: ([
						{ charset: App.config.html.charset },
						{ name: "viewport", content: "width=device-width, initial-scale=1.0" }
					]:Array<Dynamic>),
#end
				favicon: {
					href: "data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA/7VrAP8AJgD///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAEQARAAEAEQERABEQEQARERERERERABEREREREREAEREREREREQARERERERERABERMxERMxEAERMyIRMyIQABEzIhEzIgAAETMzETMzAAAREzEREzEAAAEREREREAAAABEREREAAAAAABERAAAAAAAAAAAAAAD//wAAuZ0AAJGJAACAAQAAgAEAAIABAACAAQAAgAEAAIABAADAAwAAwAMAAMADAADgBwAA8A8AAPw/AAD//wAA",
					type: 'image/x-icon',
					rel: 'icon'
				},

				brand: 'Home',
				brandPage: '/',

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
			};
		}
		return current;
	}

}
