import ithril.*;
import ithril.M.*;
using Reflect;

// Website top level page wrapper wraps all pages
class Website extends Component {
#if browser
	// when component is created or updated, update favicon and title
	override public function oncreate(vnode) setup(vnode);
	override public function onupdate(vnode) setup(vnode);
	function setup(vnode) {
		js.Browser.document.title = vnode.attrs.title;
		if (vnode.attrs.link == null) return;
		for (link in (vnode.attrs.links:Array<Dynamic>)) {
			if (link.rel == "icon") {
				var icon = js.Browser.document.head.querySelector('link[rel=icon]');
				icon.setAttribute('href', link.href);
				icon.setAttribute('type', link.type);
				break;
			}
		}
	}
#end

	override public function view(vnode:Vnode) @m[
#if !browser
		(!doctype)
		(html(lang='en'))

		(head)
			(title > vnode.attrs.title)
			(vnode.attrs.meta >> data)
				(meta(data))
			(vnode.attrs.link => attributes)
				(link(attributes))
			(vnode.attrs.css >> css)
				(style(css.attributes) > @trust css.content)
		(body)
#end
			(Navigation(id='navigation')(vnode.attrs))
			[m(Type.resolveClass(vnode.attrs.component), vnode.attrs)]
			(Footer(id='footer'))
#if !browser
			(vnode.attrs.script >> script)
				(script(script.attributes) > @trust script.content)
#end
	];
}

// HomePage component
class HomePage extends Component {
	override public function view(vnode:Vnode) @m[
		(Content(header=vnode.attrs.homeHeader, text=vnode.attrs.homeText))
		(input(type='text', value=vnode.attrs.streamVal, onchange=withAttr("value", vnode.attrs.streamVal)))
		(ContentPage(vnode.attrs))
	];
}

// ContentPage component
class ContentPage extends Component {
	override public function view(vnode:Vnode) @m[
		(vnode.attrs.content => content)
			(Content(header=content.header, text=content.text))
	];
}

// Navigation component
class Navigation extends Component {
	function active(test) return test ? "active" : "";

	override public function view(vnode:Vnode) @m[
		(nav(id=vnode.attrs.id, style=vnode.attrs.style))
			(a+brand(oncreate=routeLink, href=vnode.attrs.brandPage))
				[vnode.attrs.brand]
			(ul)
				(vnode.attrs.pages.fields() >> href)
					[{
						var page = vnode.attrs.pages.field(href);
						if (page.nav != null)
							@m[
								(li(className=active(href == vnode.attrs.href)))
									(a(oncreate=routeLink, href=href, className=active(href == vnode.attrs.href)) > page.nav)
							]
						else
							@m[ ];
					}]
	];
}

// Footer component
class Footer extends Component {
	override public function view(vnode) @m[
		(div(id=vnode.attrs.id, style=vnode.attrs.style))
			(hr)
	];
}

// Page component
class Content extends Component {
	override public function view(vnode:Vnode) @m[
		(div.content(id=vnode.attrs.id, style=vnode.attrs.style))
			(div)
				(h2 > vnode.attrs.header)
			(div > vnode.attrs.text)
	];
}
