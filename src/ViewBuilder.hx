import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using haxe.macro.ExprTools;

typedef ViewContext = {
	block: Expr,
	elements: Array<Cell>
}

typedef Cell = {
	tag: String,
	attrs: Dynamic,
	children: Array<Dynamic>
}

typedef UnwrappedSelector = {
	tag: String,
	classes: Array<String>,
	id: String
}

class ViewBuilder {

	macro static public function build(): Array<Field> {
		return Context.getBuildFields().map(inlineView);
	}
	
	static function inlineView(field: Field) {
		return switch (field.kind) {
			case FieldType.FFun(func): 
				parseBlock(func.expr);
				field;
			default: field;
		}
	}
	
	static function parseBlock(e: Expr) {
		//trace(e);
		switch (e.expr) {
			case ExprDef.EBlock(exprs):
				if (exprs.length == 1)
					parseCalls(exprs[0], {
						block: e,
						elements: []
					});
			default:
		}
	}
	
	static function parseCalls(e: Expr, ctx: ViewContext) {
		switch (e) {
			case _.expr => ExprDef.ECall(callExpr, params):
				var element = chainElement(params);
				if (element != null) {
					ctx.elements.push(element);
					parseCalls(callExpr, ctx);
				}
			case macro (view):
				ctx.block.expr = Context.makeExpr(ctx.elements, Context.currentPos()).expr;
			default:
		}
	}
	
	static function chainElement(params: Array<Expr>): Null<Cell> {
		if (params.length > 0) {
			var e = params[0];
			switch (e.expr) {
				case ExprDef.EConst(c):
					switch (c) {
						case Constant.CIdent(s): 
							return {
								tag: s, attrs: {}, children: []
							};
						default:
					}
				case ExprDef.EField(_, _) | ExprDef.EBinop(_, _, _) | ExprDef.EArray(_, _):
					var selector = parseSelector(e.toString().replace(' ', ''));
					return {
						tag: selector.tag, attrs: {
							'class': selector.classes.join(' '),
							'id': selector.id
						}, children: []
					};
				default:
			}
		}
		
		return null;
	}
	
	static function parseSelector(selector: String): UnwrappedSelector {
		selector = selector.replace('.', ',.').replace('+', ',+');
		var parts: Array<String> = selector.split(',');
		
		var tag = '';
		var id = '';
		var classes: Array<String> = [];
		
		for (part in parts) {
			var value = part.substr(1);
			switch (part.charAt(0)) {
				case '.': classes.push(value);
				case '+': id = value;
				default: tag = part;
			}
		}
		
		return {
			tag: tag, 
			classes: classes,
			id: id
		};
	}
	
}