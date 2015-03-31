import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using haxe.macro.ExprTools;

typedef ViewContext = {
	block: Expr,
	elements: Array<Block>
}

typedef Cell = {
	tag: String,
	attrs: Dynamic,
	children: Array<Dynamic>
}

enum Block {
	ElementBlock(data: Element);
	ExprBlock(e: Expr);
}

typedef Selector = {
	tag: String,
	classes: Array<String>,
	id: String
}

typedef Element = {
	selector: Selector,
	attributes: Null<Expr>,
	content: Null<Expr>,
	line: Int	
}

typedef PosInfo = {
	file: String,
	line: Int,
	start: Int,
	end: Int
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
				var block = chainElement(params);
				if (block != null) {
					trace(block);
					ctx.elements.push(block);
					parseCalls(callExpr, ctx);
				}
			case macro (view):
				ctx.block.expr = Context.makeExpr(null, Context.currentPos()).expr;
			default:
		}
	}
	
	static function element(): Element {
		return {
			selector: {
				tag: '',
				classes: [],
				id: '',
			},
			attributes: null,
			content: null,
			line: 0
		};
	}
	
	static function chainElement(params: Array<Expr>): Null<Block> {
		if (params.length == 0 || params.length > 3) 
			return null;
		
		if (params.length == 1) {
			var e = params[0];
			switch (e.expr) {
				case ExprDef.EParenthesis(e):
					return ExprBlock(e);
				default:
			}
		}
				
		var element = element();
		var e = params[0];
		switch (e.expr) {
			case ExprDef.EConst(c):
				switch (c) {
					case Constant.CIdent(s):
						element.selector.tag = s;
					default: return null;
				}
			case ExprDef.EField(_, _) | ExprDef.EBinop(_, _, _) | ExprDef.EArray(_, _):
				element.selector = parseSelector(e.toString().replace(' ', ''));
			default: return null;
		}
		
		if (params.length > 1)
			element.attributes = params[1];
		
		if (params.length > 2)
			element.content = params[2];

		element.line = posInfo(e.pos).line;
			
		return ElementBlock(element);
	}
	
	static function parseSelector(selector: String): Selector {
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
	
	static function posInfo(pos: Position): PosInfo {
		var info = Std.string(pos);
		var check = ~/([0-9]+): characters ([0-9]+)-([0-9]+)/;
		check.match(info);
		return {
			file: Context.getPosInfos(pos).file,
			line: Std.parseInt(check.matched(1)),
			start: Std.parseInt(check.matched(2)),
			end: Std.parseInt(check.matched(3))
		};
	}
	
}