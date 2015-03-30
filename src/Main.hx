import mithril.M;

class MacroCall {
	public function new() {
		
	}
}

class Main/* implements Module<Main>*/ {
	public static function main() {
		//M.module(js.Browser.document.getElementById('main'), new Main());
		new Main();
	}
	
	public function new() {
		view();
	}
	
	public function view()
		TestMacro.template(
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
							(for (item in items) (li)(a, { href:'blabla' }, item.title))
							(items.map(function(item)
								(li)(a, { href:'blabla' }, item.title)
							))
							(li.last)
						(div.activity)
		);

}