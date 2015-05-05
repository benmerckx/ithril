import ithril.Ithril;
import mithril.M;
import js.Browser;

class Example implements ithril.Ithril {
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
		
		return ithril
			(div)
				(div+header)
					(h1[style="color:red"].test, 'Heading')
					(h2, "Subheader")
				(nav)
					(ul)
						[for (item in menu) ithril(li, {}, item.title)]
				(div+footer)
					(p, 'Footer text')
		;
	}

}