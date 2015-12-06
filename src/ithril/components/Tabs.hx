package ithril.components;

import ithril.Component;

class Tab extends Component<{label: String}> {
	var parent: Tabs;
	
	public function labelView() {
		return ithril
			(a, {onclick: function() parent.setSelected(this), 'class': parent.isSelected(this)?'active':''}, label)
		;
	}

	public function view() {
		return ithril
			(div.tab)
				[children]
		;
	}
}

class Tabs extends Component<{?attrs: Dynamic}> {
	var selected = 0;
	var children: Array<Tab>;

	public function setSelected(tab: Tab) {
		selected = children.indexOf(tab);
	}

	public function isSelected(tab: Tab) {
		return children.indexOf(tab) == selected;
	}

	public function view() {
		if (attrs == null) attrs = {};
		return ithril
			(div.tabs, attrs)
				(nav)
					[for (tab in children) tab.labelView()]
				[children[selected]]
		;
	}
}
