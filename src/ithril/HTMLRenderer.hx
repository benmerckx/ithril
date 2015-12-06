package ithril;

using Reflect;
using Lambda;

class HTMLRenderer {

	var VOID_TAGS = [
		'area', 'base', 'br', 'col', 'command', 'embed', 'hr',
		'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track',
		'wbr', '!doctype'
	];
	var space: String;

	function new(space) {
		this.space = space;
	}

	inline function escape(str: String): String {
		return StringTools.htmlEscape(str);
	}

	function createChildrenContent(view, level) {
		if(Std.is(view.children, Array) && view.children.length == 0)
			return '';

		return renderView(view.children, level);
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

	function attribute(name: String, value: Dynamic) {
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

		return ' ' + (name == 'className' ? 'class' : name) + '="' + escape(value) + '"';
	}

	function createAttrString(attrs: Dynamic) {
		if (attrs == null) return '';

		return Reflect.fields(attrs).map(function(name) {
			return attribute(name, attrs.field(name));
		}).join('');
	}

	public function renderView(view: Dynamic, level = 0) {
		if (Std.is(view, String))
			return spacer(level) + escape(view) + lineEnd();

		if (view == null) return '';

		if (Std.is(view, Array)) {
			return (view: Array<Dynamic>).map(renderView.bind(_, level + 1)).join('');
		}

		if (Reflect.isObject(view)) {
			var type = Type.getClass(view);
			if (type != null) {
				var fields = Type.getInstanceFields(type);
				if (fields.has('view')) {
					var scope = fields.has('controller') ? view.controller() : {};
					var result = renderView(view.view(), level);
					if (scope.hasField('onunload'))
						untyped scope.onunload();
					return result;
				}
			}
		}

		// TODO: check for other targets
		if (view.hasField("$trusted")) {
			return Std.string(view);
		}

		if (VOID_TAGS.indexOf(view.tag.toLowerCase()) >= 0) {
			return spacer(level) + '<' + view.tag + createAttrString(view.attrs) + '>' + lineEnd();
		}

		var children = createChildrenContent(view, level+1);

		return [
			spacer(level) + '<', view.tag, createAttrString(view.attrs), '>' + lineEnd(),
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
		return renderer.renderView(view);
	}

}
