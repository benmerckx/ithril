import ithril.Component;

import ithril.components.Tabs;
import ithril.components.Text;

class Web extends Component {
	var tabs = [1, 2, 3, 4, 5];
	var inputValue = 'Hello';

	public function view() {
		#if js return body(); #end
		return ithril
			(!doctype)
			(meta[charset="utf-8"])
			(link[href="layout.css"][rel="stylesheet"])
			(body)
				[body()]
			(script[src="https://cdnjs.cloudflare.com/ajax/libs/mithril/0.2.0/mithril.min.js"])
			(script[src="main.js"])
		;
	}

	public function body() {
		return ithril
			(div.tabs-example)
				(Tabs)
					(Tab, 'Tab label')
						['Tab 1']
					(Tab, 'Tab label 2')
						['Tab 2']
				(Tabs)
					[for (i in tabs) ithril
						(Tab, 'Label '+i)
							['Content '+i]
					]
				(a, {onclick: function() tabs.push(tabs.length + 1)}, 'Add tab')
				(div)
					(h1, {}, inputValue)
					(Text, {oninput: function(e) inputValue = e.target.value, value: inputValue, multiline: true})
		;
	}

	public static function main() {
		#if !js
		sys.io.File.saveContent('web/public/index.html', new Web().asHTML());
		#else
		untyped m.mount(js.Browser.document.body, new Web());
		#end
	}
}
