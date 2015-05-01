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
			(div)
				(div+header)
					(h1[style="color:red"].test, 'Heading')
					(h2, "Subheader")
				(nav)
					(ul)
						[for (item in menu) (view)(li, {}, item.title)]
				(div+footer)
					(p, 'Footer text')
		;
	}

}