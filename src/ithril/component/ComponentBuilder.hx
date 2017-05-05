package ithril.component;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

using Lambda;

@:access(haxe.macro.TypeTools)
class ComponentBuilder {
	static var params: Array<Type>;

	static public function buildGeneric() {
		var attrs = (macro: {});
		switch (Context.getLocalType()) {
			case TInst(cl, paramList):
					params = paramList;
					if (params.length > 0)
						attrs = TypeTools.toComplexType(params[0]);
			default:
				Context.error("Class expected", Context.currentPos());
		}
		return ComplexType.TPath({
			sub: 'ComponentAbstract',
			params: [TPType(attrs)],
			pack: ['ithril'],
			name: 'Component'
		});
	}

	static public function build() {
		// add @:keep metadata to component functions called by mithril
		var fields = Context.getBuildFields();
		var keepFields = [ 'new', 'view', 'oninit', 'oncreate', 'onupdate', 'onbeforeremove', 'onremove', 'onbeforeupdate' ];
		fields.map(function(field) {
			if (keepFields.indexOf(field.name) > -1) {
				field.meta = field.meta == null ? [] : field.meta;
				field.meta.push({
					pos: Context.currentPos(),
					params: null,
					name: ':keep'
				});
			}
		});
		return fields;
	}
}
