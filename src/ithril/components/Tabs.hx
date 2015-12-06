package ithril.components;

import ithril.Component;

class Tab extends Component {
	var label: String;
	
	function attributes(label: String) {
		this.label = label;
	}
	
	public function labelView() {
		var tabs = cast(parent, Tabs);
		return ithril
			(a, {onclick: function() tabs.setSelected(this), 'class': tabs.isSelected(this)?'active':''}, label)
		;
	}
	
	public function view() {
		return ithril
			(div.tab)
				[children]
		;
	}
}

class Tabs extends Component {
	var selected = 0;
	
	public function setSelected(tab: Tab) {
		selected = children.indexOf(tab);
	}
	
	public function isSelected(tab: Tab) {
		return children.indexOf(tab) == selected;
	}
	
	public function view() {
		return ithril
			(div.tabs)
				(nav)
					[for (tab in children) tab.labelView()]
				[children[selected]]
		;
	}
}