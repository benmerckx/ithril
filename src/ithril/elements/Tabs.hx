package ithril.elements;

import ithril.Component;

typedef TabEvents = {
	select: Tab -> Void
}

class Tab extends Component<String> {
	
	var random = Math.random();
	
	override public function mount() {
		trace('mounted tab');
	}
	
	override public function unmount() {
		trace('unmounted tab');
	}
	
	public function labelView(selected, onclick: Tab -> Void) [
		(a (onclick = onclick.bind(this), 'class' = selected?'active':'') > state)
	];

	public function view() [
		(div.tab)
			[children]
			(div.random > random)
	];
}

class Tabs<T> extends Component<Dynamic, Tab> {
	var selected = 0;

	public function setSelected(tab: Tab) {
		selected = children.indexOf(tab);
	}

	function isSelected(tab: Tab) {
		return children.indexOf(tab) == selected;
	}

	public function view() [
		(div.ithril)
			(div.tabs (state == null ? {} : state))
				(nav)
					(children => tab)
						[tab.labelView(isSelected(tab), setSelected)]
				[children[selected]]
	];
}
