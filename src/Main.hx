import js.Browser;
class Main implements View {
	public static function main() {
		new Main();
	}
	
	public function new() {
		untyped m.render(Browser.document.getElementById('main'), view());
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
			(div.test)
				(h1, {}, 'Test template')
				
				(nav.main-nav)
					(ul)
						(([for (item in menu) (view)
							(li)
								(a, {href: item.href}, item.title)
						]))
						(li)
							(a, { href: '/' }, 'Home')
				
				(div.form)
					(form, {method: 'post', action: '/'})
						(label.field)
							(('Your name: '))(input[type="text"], {name: "name"})
						(label.field)
							(('Your e-mail: '))(input[type="email"], {name: "mail"})
						(button+submit, {}, "Submit form")
					
				(footer.few.more.classes+id)
					(('Footer text'))
		;
	}

}