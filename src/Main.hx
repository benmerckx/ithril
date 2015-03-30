typedef Template = {
	tag: String,
	attrs: Dynamic,
	children: Array<Template>
}

class Main implements View {
	public static function main() {
		new Main();
	}
	
	public function new() {
		//trace(view());
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
	public function view() { 
		(view)
			(nav.breadcrumbs)
			(div.form)
				(h1+id, entry.language.title)
				(nav)
					(a.active, {'data-tab': 'main'})
					(a, {'data-tab': 'meta'}, language.entry_nav_doc)
					(a, {'data-tab': 'settings'}, language.entry_nav_doc)
				(div.edit-status, {style: {display: none}})
				(div.tab.open.main)
					(form)
						(div.components)
				(div.tab.meta)
					(div.components)
				(div.tab.settings)
					(div.components)
					(a.move-to, language.move_entry_to)
				(aside)
		;
		/*return (view)
			(div)
				(ul)
					(li)
					(li)
					(li)
		;*/
	}

}