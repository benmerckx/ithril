import ithril.View;
import mithril.M;
import js.Browser;

class Example implements ithril.View {
	public static function main() {
		new Example();
	}
	
	public function new() {
		M.render(Browser.document.getElementById('main'), view());
	}

	public function view() {
		var menu = [{
			title: 'link1',
			href: '/'
		}, {
			title: 'link2',
			href: '/link2'
		}];
		
		return (view)
			(html, {xlmns: 'http://www.w3.org/1999/xhtml', lang: 'en', 'xml:lang': 'en'})
				(head)
					(title, 'BoBlog')
					(meta, {'http-equiv': 'Content-Type', content: 'text/html; charset=utf-8'})
					(link, {rel: 'stylesheet', href: 'main.css', type: 'text/css'})
				(body)
					(div+header)
						(h1, 'BoBlog')
						(h2, "Bob's Blog")
					(nav)
						(ul)
							[for (item in menu) (view)(li, {}, item.title)]
					(div+footer)
						(p, 'All content &copy; Bob')
		;
	}

}