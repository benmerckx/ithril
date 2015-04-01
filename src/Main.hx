import js.Browser;
class Main implements View {
	public static function main() {
		new Main();
	}
	
	public function new() {
		trace(view());
		untyped m.render(Browser.document.getElementById('main'), view());
	}
	/*
	 (nav.breadcrumbs)
			(div.form)
				(h1+id, entry.language.title)
				(nav)
					(a.active, {'data-tab': 'main'})
					(a, {'data-tab': 'meta'}, language.entry_nav_doc)
					(a, {'data-tab': 'settings'}, language.entry_nav_doc)
				(div.edit-status[placeholder='abc'], {style: {display: none}})
				(div.tab.open.main)
					(form)
						(div.components)
				(div.tab.meta)
					(div.components)
				(div.tab.settings)
					(div.components)
					(a.move-to, language.move_entry_to)
				(aside)
				(div.language)
					(h1, language.languages)
					(ul)
						(for (item in items) template(li)(a, { href:'blabla' }, item.title))
						(items.map(function(item)
							_(li)(a, { href:'blabla' }, item.title)
						))
						(li.last)
					(div.activity)
	 */
					
	 /*(view)
			(ul)
				(li)(li)
			(div)
				(("Hello"))(b, {}, "world")(("!"))
			(nav.breadcrumbs)
			(div.form)
				(h1+id, entry.language.title)
				(nav)
					(a.active, {id: 'id', id: 'id2'})
				(div.edit-status, {style: {display: none}})
				(div.tab.open.main)
					(form)
						(div.components)
				(div.tab.meta)
					(div.components)
					((textNode))
				(div.tab.settings)
					(div.components)
					(a.move-to)
				(aside)
		;
		*/
	public function view() {
		var list = [{
			title: 'Item 1',
			body: 'Body text'
		}, {
			title: 'Item 2',
			body: 'Body text 2'
		}];
		
		return (view)
			(ul)
				(([for (item in list) (view)(li)
					(h1)
						((item.title))(span, {}, 'ok')
					(p)
						((item.body))
				]))
				(li)
					(('ok'))
		;
	}

}