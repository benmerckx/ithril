package ithril;

using Reflect;

class HTMLRenderer {
	
	var VOID_TAGS = [
		'area', 'base', 'br', 'col', 'command', 'embed', 'hr',
		'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track',
		'wbr', '!doctype'
	];
	
	function new() {}
	
	inline function escape(str: String): String {
		return StringTools.htmlEscape(str);
	}
	
	function createChildrenContent(view) {
		if(Std.is(view.children, Array) && view.children.length == 0)
			return '';

		return renderView(view.children);
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
	
	public function renderView(view: Dynamic) {
		if (Std.is(view, String))
			return escape(view);
		
		if (view == null) return '';
		
		if (Std.is(view, Array)) {
			return (view: Array<Dynamic>).map(renderView).join('');
		}
		
		if (view.hasField('view')) {
			var scope = view.hasField('controller') ? view.controller : {};
			var result = renderView(view.view(scope));
			if (scope.hasField('onunload'))
				untyped scope.onunload();
			return result;
		}
		
		// TODO: check for other targets
		if (view.hasField("$trusted")) {
			return Std.string(view);
		}
		
		var children = createChildrenContent(view);
		if (children == '' && VOID_TAGS.indexOf(view.tag.toLowerCase()) >= 0) {
			return '<' + view.tag + createAttrString(view.attrs) + '>';
		}
		
		return [
			'<', view.tag, createAttrString(view.attrs), '>',
			children,
			'</', view.tag, '>',
		].join('');
	}

	public static function render(view: Dynamic): String {
		var renderer = new HTMLRenderer();
		return renderer.renderView(view);
	}
	
}