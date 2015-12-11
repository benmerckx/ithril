package ithril.elements;

import ithril.Component;

typedef TabEvents = {
	select: Tab -> Void
}

class Tab extends Component<String> {
	public function labelView(selected, onclick: Tab -> Void) {
		return ithril
			(a, {onclick: onclick.bind(this), 'class': selected?'active':''}, state)
		;
	}

	public function view() {
		return ithril
			(div.tab)
				[children]
		;
	}
}

class Tabs extends Component<Dynamic, Tab> {
	var selected = 0;

	public function setSelected(tab: Tab) {
		selected = children.indexOf(tab);
	}

	function isSelected(tab: Tab) {
		return children.indexOf(tab) == selected;
	}

	public function view() {
		if (state == null) state = {};
		return ithril
			(div.ithril)
				(div.tabs, state)
					(nav)
						[for (tab in children) tab.labelView(isSelected(tab), setSelected)]
					[children[selected]]
		;
	}
}
