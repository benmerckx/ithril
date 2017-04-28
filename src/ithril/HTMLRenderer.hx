package ithril;

using Reflect;
using Lambda;

@:enum 
abstract Namespace(String) from String to String {
	var None = '';
	var Svg = 'http://www.w3.org/2000/svg';
}

class HTMLRenderer {

	var VOID_TAGS = [
		'area', 'base', 'br', 'col', 'command', 'embed', 'hr',
		'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track',
		'wbr', '!doctype', 'html'
	];
	var space: String;

	function new(space) {
		this.space = space;
	}

	inline function escape(str: String): String {
		return StringTools.htmlEscape(str);
	}

	function createChildrenContent(view, level, namespace: Namespace) {
		if(Std.is(view.children, Array) && view.children.length == 0)
			return '';

		return renderView(view.children, level, namespace);
	}

	function removeEmpty(n: String) {
		return n != '' && n != null;
	}

	function camelToDash(str: String) {
        var outStr = "";
        for (i in 0 ... str.length) {
            var chr = str.charCodeAt(i);
            if (chr >= 'A'.code && chr <= 'Z'.code) {
                outStr += '-' + String.fromCharCode(chr - 'A'.code + 'a'.code);
            } else {
                outStr += String.fromCharCode(chr);
            }
        }
        return outStr;
    }

	function attribute(name: String, value: Dynamic, namespace: Namespace) {
		switch namespace {
			case Namespace.Svg: 
				if (name == 'href')
					name = 'xlink:href';
			default:
		}
		
		if (Reflect.isFunction(value) || value == null)
			return '';

		if (Std.is(value, Bool))
			return value ? ' ' + name : '';

		if (name == 'style') {
			if (value == '')
				return '';

			var styles = '';

			if (Reflect.isObject(styles)) {
				styles = Reflect.fields(value).map(function(key) {
					var prop = value.field(key);
					return prop != '' ? [camelToDash(key).toLowerCase(), prop].join(':') : '';
				}).filter(removeEmpty).join(';');
			}

			if (Std.is(value, String)) {
				styles = value;
			}

			return styles != '' ? ' style="' + escape(styles) + '"' : '';
		}

		return ' ' + (name == 'className' ? 'class' : name) + '="' + escape(Std.string(value)) + '"';
	}

	function createAttrString(attrs: Dynamic, namespace: Namespace) {
		if (attrs == null) return '';

		return Reflect.fields(attrs).map(function(name) {
			return attribute(name, attrs.field(name), namespace);
		}).join('');
	}

	public function renderView(view: Dynamic, level = 0, namespace: Namespace) {
		if (Std.is(view, String) || Std.is(view, Int) || Std.is(view, Float) || Std.is(view, Bool))
			return spacer(level) + escape(Std.string(view)) + lineEnd();

		if (view == null) return '';

		if (Std.is(view, Array)) {
			return (view: Array<Dynamic>).map(renderView.bind(_, level + 1, namespace)).join('');
		}

		if (Reflect.isObject(view)) {
			var type = Type.getClass(view);
			if (type != null) {
				var fields = Type.getInstanceFields(type);
				if (fields.has('view')) {
					var scope = fields.has('controller') ? view.controller() : {};
					var result = renderView(view.view(), level, namespace);
					if (scope.hasField('onunload'))
						untyped scope.onunload();
					return result;
				}
			}
		}

		// TODO: check for other targets
		if (Std.is(view, ithril.Ithril.TrustedHTMLAccess)) {
			return Std.string(view);
		}
		
		if (Std.is(view.tag, String) && VOID_TAGS.indexOf(view.tag.toLowerCase()) >= 0) {
			return spacer(level) + '<' + view.tag + createAttrString(view.attrs, namespace) + '>' + lineEnd();
		}

		if (view.tag == '#') {
			return spacer(level) + view.children.toString() + lineEnd();
		}

		if (view.tag == '[') {
			return createChildrenContent(view, level, namespace);
		}
		
		if (view.tag == 'svg') {
			namespace = Namespace.Svg;
			view.attrs.xmlns = namespace;
		}
		
		var children = createChildrenContent(view, level, namespace);

		return [
			spacer(level) + '<', view.tag, createAttrString(view.attrs, namespace), '>' + lineEnd(),
			children,
			spacer(level) + '</', view.tag, '>' + lineEnd(),
		].join('');
	}

	function lineEnd() {
		if (space == '') return '';
		else return "\n";
	}

	function spacer(level) {
		if (space == '') return '';
		return [for (i in 0 ... level) ''].join(space);
	}

	public static function render(view: Dynamic, space = ''): String {
		var renderer = new HTMLRenderer(space);
		return renderer.renderView(view, Namespace.None);
	}

}
