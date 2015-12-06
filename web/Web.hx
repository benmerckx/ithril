import ithril.Component;
import ithril.components.Tabs;

class Web extends Component {
	var tabs = [1, 2, 3, 4, 5];
	public function wrap() {
		return ithril
			(!doctype)
			(meta[charset="utf-8"])
			(link[href="layout.css"][rel="stylesheet"])
			(body)
				[view()]
			(script[src="https://cdnjs.cloudflare.com/ajax/libs/mithril/0.2.0/mithril.min.js"])
			(script[src="main.js"])
		;
	}

	public function view() {
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
				(a, {onclick: function() tabs.push(1)}, 'Add tab')
		;
	}

	public static function main() {
		#if !js
		sys.io.File.saveContent('web/public/index.html', ithril.HTMLRenderer.render(new Web().wrap()));
		#else
		untyped m.mount(js.Browser.document.body, new Web());
		#end
	}
}
