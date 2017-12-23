import ithril.*;
import ithril.M.*;

class Web extends Component {
	override public function view(vnode) @m[
#if nodejs
		(!doctype)
		(meta[charset="utf-8"])
		(link[href="layout.css"][rel="stylesheet"])
		(body)
#end
			(div.intro)
				(h1 > 'Ithril example')
				(p > 'Hello world')
#if nodejs
		(script[src="https://cdnjs.cloudflare.com/ajax/libs/mithril/1.1.6/mithril.min.js"])
		(script[src="main.js"])
#end
	];

}

class Main {
	public static function main() {
		// On the server
		#if nodejs 
		HTMLRenderer.render(Web).then(function(html) Sys.print(html));
		#else
		// On the client
		M.mount(js.Browser.document.body, Web);
		#end
	}
}
