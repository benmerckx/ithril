import ithril.Component;
import ithril.elements.Tabs;
import ithril.elements.Text;

class Web extends Component {
	var tabs = [1, 2, 3, 4, 5];
	var inputValue = 'Hello';

	public function view() {
		#if js return body(); #end
		[
			(!doctype)
			(meta[charset="utf-8"])
			(link[href="layout.css"][rel="stylesheet"])
			(body)
				[body()]
			(script[src="https://cdnjs.cloudflare.com/ajax/libs/mithril/0.2.0/mithril.min.js"])
			(script[src="main.js"])
		];
	}

	public function body() [
		(div.tabs-example)
			(Tabs)
				(Tab ('Tab label'))
					['Tab 1']
				(Tab ('Tab label 2'))
					['Tab 2']
			(Tabs)
				(tabs => i)
					(Tab ('Label '+i))
						['Content '+i]
			(a (onclick = function() tabs.push(tabs.length + 1)) > 'Add tab')
			(div)
				(h1 > inputValue)
				(Text (oninput = function(e) inputValue = e.field.value, value = inputValue, multiline = true))
	];

	public static function main() {
		#if !js
		sys.io.File.saveContent('web/public/index.html', new Web().asHTML());
		#else
		untyped m.mount(js.Browser.document.body, new Web());
		#end
	}
}
