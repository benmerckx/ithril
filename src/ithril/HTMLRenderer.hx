package ithril;

@:enum
abstract Namespace(String) from String to String {
	var None = '';
	var Svg = 'http://www.w3.org/2000/svg';
}

class HTMLRenderer {

	static var VOID_TAGS = [
		'area', 'base', 'br', 'col', 'command', 'embed', 'hr',
		'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track',
		'wbr', '!doctype', 'html'
	];

	inline static function escapeHtml(str: String, ?quotes:Bool):String return StringTools.htmlEscape(Std.string(str), quotes);
	inline static function removeEmpties(n:String) return n != '' && n != null;

	static inline function camelToDash(str:String) {
        var outStr = "";
        for (i in 0 ... str.length) {
            var chr = str.charCodeAt(i);
            if (chr >= 'A'.code && chr <= 'Z'.code)
                outStr += '-' + String.fromCharCode(chr - 'A'.code + 'a'.code);
            else
                outStr += String.fromCharCode(chr);
        }
        return outStr;
	}

	static function setHooks (component:Dynamic, vnode:Vnode, hooks:Array<Dynamic>) {
		if (component.oninit != null) component.oninit(vnode);
		if (component.onremove != null) hooks.push(function () component.onremove(vnode));
	}

	static function attribute(name: String, value: Dynamic, escapeAttributeValue, namespace: Namespace) {
		if (Reflect.isFunction(value) || value == null) return '';

		if (Std.is(value, Bool)) return value ? ' ' + name : '';

		switch namespace {
			case Namespace.Svg:
				if (name == 'href')
					name = 'xlink:href';
			default:
		}

		if (name == 'style') {
			if (value == '') return '';

			var styles = '';

			if (Reflect.isObject(styles)) {
				styles = Reflect.fields(value).map(function(key) {
					var prop = Reflect.field(value, key);
					return prop != '' ? [camelToDash(key).toLowerCase(), prop].join(':') : '';
				}).filter(removeEmpties).join(';');
			}

			if (Std.is(value, String)) styles = value;

			return styles != '' ? ' style="' + escapeAttributeValue(styles, true) + '"' : '';
		}

		return ' ' + (name == 'className' ? 'class' : name) + '="' + escapeAttributeValue(Std.string(value), true) + '"';
	}

	static function createAttrString(view: Dynamic, escapeAttributeValue, namespace: Namespace)
		if (view.attrs == null)
			return '';
		else
			return Reflect.fields(view.attrs).map(function(name) return attribute(name, Reflect.field(view.attrs, name), escapeAttributeValue, namespace)).join('');

	static function createChildrenContent (view:Dynamic, options:Dynamic, hooks:Array<Dynamic>, level, namespace) {
		var txt = (view.text == null || view.text == '') ? '' : spacer(options, level) + options.escapeString(view.text, true) + lineEnd(options);

		if (Std.is(view.children, Array) && view.children.length == 0)
			return txt;
		else
			return txt + _render(view.children, options, hooks, level, namespace);
	}

	public static function render (view:Dynamic, ?attrs:Dynamic, ?options:Dynamic) {
		if (Std.is(view, Class)) return render({ tag: view, attrs: attrs }, attrs, options);
		var hooks = [];

		var defaultOptions = {
			escapeAttributeValue: escapeHtml,
			escapeString: escapeHtml,
			strict: false,
			space: ''
		}

		if (options == null)
			options = defaultOptions;
		else
			Reflect.fields(defaultOptions).map(function (key)
				if (!Reflect.hasField(options, key)) Reflect.setField(options, key, Reflect.field(defaultOptions, key)));

		var result = _render(view, options, hooks);
		hooks.map(function (hook) { hook(); });

		return result;
	}

	static function _render (view:Dynamic, options:Dynamic, hooks:Array<Dynamic>, level = 0, namespace = Namespace.None) {
		if (Std.is(view, String)) return spacer(options, level) + options.escapeString(view, false) + lineEnd(options);

		if (Std.is(view, Int) || Std.is(view, Float) || Std.is(view, Bool)) return view;

		if (view == null) return '';

		if (Std.is(view, Array)) {
			var result = '';
			for (v in (view:Array<Dynamic>))
				result += _render(v, options, hooks, level + 1, namespace);
			return result;
		}

		if (view.attrs) setHooks(view.attrs, view, hooks);

		var vnode:Vnode = {
			tag: view.tag,
			children: view.children,
			attrs: view.attrs != null ? view.attrs : {}
		}

		if (Std.is(view.tag, Class)) {
			var component = Type.createInstance(view.tag, [vnode]);
			vnode.state = component;
			setHooks(component, vnode, hooks);
			return _render(component.view(vnode), options, hooks, level, namespace);
		}

		if (view.tag == '<') return spacer(options, level) + view.children + lineEnd(options);

		if (view.tag == 'svg') {
			namespace = Namespace.Svg;
			view.attrs.xmlns = namespace;
		}

		var children = createChildrenContent(view, options, hooks, level, namespace);
		if (view.tag == '#') return spacer(options, level) + options.escapeString(children, false) + lineEnd(options);

		if (view.tag == '[') return children;

		if (children != null && (options.strict || (Std.is(view.tag, String) && VOID_TAGS.indexOf(view.tag.toLowerCase()) >= 0)))
			return spacer(options, level) + '<' + view.tag + createAttrString(view, options.escapeAttributeValue, namespace) + (options.strict ? '/' : '') + '>' + lineEnd(options);

		return [
			spacer(options, level) + '<', view.tag, createAttrString(view, options.escapeAttributeValue, namespace), '>' + lineEnd(options),
			children,
			spacer(options, level) + '</', view.tag, '>' + lineEnd(options)
		].join('');
	}

	static public function lineEnd(options) return options.space == '' ? '' : "\n";

	static function spacer(options, level) {
		if (options.space == '') return '';
		return [for (i in 0 ... level) ''].join(options.space);
	}
}
