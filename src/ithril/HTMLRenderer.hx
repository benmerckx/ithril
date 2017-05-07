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

	static function setHooks(component:Dynamic, vnode:Vnode, hooks:Array<Dynamic>) {
		var promise = null;
		if (component != null) {
			if (component.oninit != null) promise = component.oninit(vnode);
			if (component.onremove != null) hooks.push(function () return component.onremove(vnode));
		}
#if js
		if (promise == null) return new js.Promise(function(resolve:Dynamic->Void, reject) resolve(null));
#end
		return promise;
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

	static function createAttrString(view:Dynamic, escapeAttributeValue, namespace: Namespace)
		if (view.attrs == null)
			return '';
		else
			return Reflect.fields(view.attrs).map(function(name) return attribute(name, Reflect.field(view.attrs, name), escapeAttributeValue, namespace)).join('');

	static function createChildrenContent(view:Dynamic, options:Dynamic, hooks:Array<Dynamic>, level, namespace) {
#if js
		return new js.Promise(function (resolve, reject) {
#end
			var txt = (view.text == null || view.text == '') ? '' : spacer(options, level) + options.escapeString(view.text, true) + lineEnd(options);

#if !js
			if (Std.is(view.children, Array) && view.children.length == 0)
				return txt;
			else
				return txt + Std.string(_render(view.children, options, hooks, level, namespace));
#else
			if (Std.is(view.children, Array) && view.children.length == 0)
				resolve(txt);
			else
				_render(view.children, options, hooks, level, namespace).then(function(rslt) resolve(txt + rslt));
		});
#end
	}

	static public function render (view:Dynamic, ?attrs:Dynamic, ?options:Dynamic)
#if js :js.Promise<Dynamic> #end
	{
#if js
		return new js.Promise(function (resolve, reject) {
			if (Std.is(view, Class)) {
				render({ tag: view, attrs: attrs }, attrs, options).then(function (rslt) resolve(rslt));
				return;
			}
#else
			if (Std.is(view, Class)) return render({ tag: view, attrs: attrs }, attrs, options);
#end
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
				Reflect.fields(defaultOptions).map(function (key) if (!Reflect.hasField(options, key)) Reflect.setField(options, key, Reflect.field(defaultOptions, key)));

#if !js
			var result = _render(view, options, hooks);
			hooks.map(function (hook) { hook(); });

			return result;
#else
			_render(view, options, hooks)
				.then(function (rslt) {
					js.Promise.all([for (h in hooks) h()]) // { var prom = h(); if (prom != null) (prom:js.Promise); }])
					.then(function (r) resolve(rslt));
				});
				//hooks.map(function (hook) { hook(); });
				//resolve(result);
			//});
		});
#end
	}

	static function _render (view:Dynamic, options:Dynamic, hooks:Array<Dynamic>, level = 0, namespace = Namespace.None)
#if js :js.Promise<Dynamic> #end
	{
#if js
		return new js.Promise(function (resolve, reject) {
#end
			if (Std.is(view, String))
#if !js
				return spacer(options, level) + options.escapeString(view, false) + lineEnd(options);
#else
			{
				resolve(spacer(options, level) + options.escapeString(view, false) + lineEnd(options));
				return;
			}
#end

			if (Std.is(view, Int) || Std.is(view, Float) || Std.is(view, Bool))
#if !js
				return spacer(options, level) + view + lineEnd(options);
#else
			{
				resolve(spacer(options, level) + view + lineEnd(options));
				return;
			}
#end

			if (view == null)
#if !js
				return '';
#else
			{
				resolve('');
				return;
			}
#end

			if (Std.is(view, Array)) {
#if !js
				var result = '';
				for (v in (view:Array<Dynamic>))
					result += _render(v, options, hooks, level + 1, namespace);
				return result;
#else
				js.Promise.all([for (v in (view:Array<Dynamic>)) _render(v, options, hooks, level + 1, namespace)])
					.then(function (result) resolve('' + result.join('')));
				return;
#end
			}

#if !js
			if (view.attrs) setHooks(view.attrs, view, hooks);
#else
			setHooks(view.attrs, view, hooks).then(function (z) {
#end
				var vnode:Vnode = {
					tag: view.tag,
					children: view.children,
					attrs: view.attrs != null ? view.attrs : {}
				};

				if (Std.is(view.tag, Class)) {
					var component = Type.createInstance(view.tag, [vnode]);
					vnode.state = component;
#if !js
					setHooks(component, vnode, hooks);
					return _render(component.view(vnode), options, hooks, level, namespace);
#else
					setHooks(component, vnode, hooks)
						.then(function (z) _render(component.view(vnode), options, hooks, level, namespace)
							.then(function (rslt) resolve(rslt)));
					return;
#end
				}

				if (view.tag == '<')
#if !js
					return spacer(options, level) + view.children + lineEnd(options);
#else
				{
					resolve(spacer(options, level) + view.children + lineEnd(options));
					return;
				}
#end

				if (view.tag == 'svg') {
					namespace = Namespace.Svg;
					view.attrs.xmlns = namespace;
				}

#if !js
				var children = createChildrenContent(view, options, hooks, level, namespace);
#else
				createChildrenContent(view, options, hooks, level, namespace).then(function (children) {
#end
					if (view.tag == '#')
#if !js
						return spacer(options, level) + options.escapeString(children, false) + lineEnd(options);
#else
					{
						resolve(spacer(options, level) + options.escapeString(children, false) + lineEnd(options));
						return;
					}
#end

					if (view.tag == '[')
#if !js
						return children;
#else
					{
						resolve(children);
						return;
					}
#end

					if (children != null && (options.strict || (Std.is(view.tag, String) && VOID_TAGS.indexOf(view.tag.toLowerCase()) >= 0)))
#if !js
						return spacer(options, level) + '<' + view.tag + createAttrString(view, options.escapeAttributeValue, namespace) + (options.strict ? '/' : '') + '>' + lineEnd(options);
#else
					{
						resolve(spacer(options, level) + '<' + view.tag + createAttrString(view, options.escapeAttributeValue, namespace) + (options.strict ? '/' : '') + '>' + lineEnd(options));
						return;
					}
#end

					var rslt:String = [
						spacer(options, level) + '<', view.tag, createAttrString(view, options.escapeAttributeValue, namespace), '>' + lineEnd(options),
						children,
						spacer(options, level) + '</', view.tag, '>' + lineEnd(options)
					].join('');
#if !js
					return rslt;
#else
					resolve(rslt);
					return;
#end

#if js
				});
			});
		});
#end
	}

	static public function lineEnd(options) return options.space == '' ? '' : "\n";

	static function spacer(options, level) {
		if (options.space == '') return '';
		return [for (i in 0 ... level) ''].join(options.space);
	}
}
