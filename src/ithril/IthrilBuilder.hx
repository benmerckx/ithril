package ithril;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using StringTools;
using haxe.macro.ExprTools;

typedef ViewContext = {
	expr: Expr,
	blocks: Array<Block>
}

typedef Cell = {
	tag: String,
	attrs: Dynamic,
	children: Dynamic//Array<Dynamic>
}

enum Block {
	ElementBlock(data: Element, pos: PosInfo);
	ExprBlock(e: Expr, pos: PosInfo);
	CustomElement(type: String, arguments: Array<Expr>, pos: PosInfo);
}

typedef BlockWithChildren = {
	block: Block,
	children: Array<BlockWithChildren>, 
	indent: Int,
	line: Int,
	parent: BlockWithChildren
}

typedef Selector = {
	tag: String,
	classes: Array<String>,
	id: String
}

typedef Element = {
	selector: Selector,
	attributes: Null<Expr>,
	inlineAttributes: Array<InlineAttribute>,
	content: Null<Expr>
}

typedef PosInfo = {
	file: String,
	line: Int,
	start: Int,
	end: Int
}

typedef InlineAttribute = {
	attr: String,
	value: Expr
}

typedef ObjField = {field : String, expr : Expr};

typedef Lines = Map<Int, Int>;
#end

class IthrilBuilder {
	#if macro
	static var lines: Lines;
	
	macro static public function build(): Array<Field> {
		return Context.getBuildFields().map(inlineView);
	}
	
	static function inlineView(field: Field) {
		return switch (field.kind) {
			case FieldType.FFun(func):
				lines = new Lines();
				func.expr.iter(parseBlock);
				field;
			default: field;
		}
	}
	
	static function parseBlock(e: Expr) {
		
		switch (e.expr) {
			case ExprDef.ECall(_, _) | ExprDef.EArray(_, _):
				parseCalls(e, {
					expr: e,
					blocks: []
				});
			default:
		}
		e.iter(parseBlock);
	}
	
	static function parseCalls(e: Expr, ctx: ViewContext) {
		switch (e) {
			case _.expr => ExprDef.ECall(callExpr, params):
				var block = chainElement(params, e);
				if (block != null) {
					ctx.blocks.push(block);
					parseCalls(callExpr, ctx);
				}
			case _.expr => ExprDef.EArray(e1, e2):
				var block = Block.ExprBlock(preprocess(e2), posInfo(e2));
				ctx.blocks.push(block);
				parseCalls(e1, ctx);
			case macro ithril:
				ctx.expr.expr = createExpr(orderBlocks(ctx)).expr;
			default:
		}
	}
	
	static function preprocess(e: Expr) return switch e {
		case macro for($head) $body: 
			macro @:pos(e.pos) ([for ($head) $body]);
		case macro while($head) $body: 
			macro @:pos(e.pos) ([while ($head) $body]);
		default: e;
	}
	
	static function createExpr(list: Array<BlockWithChildren>, ?prepend: Expr): ExprOf<Array<{tag: String,attrs: Dynamic,children: Dynamic}>> {
		var exprList: Array<Expr> = [];
		if (prepend != null) exprList.push(prepend);
		for (item in list) {
			switch (item.block) {
				case Block.ElementBlock(data, _):
					var tag = Context.makeExpr(data.selector.tag, Context.currentPos());
					exprList.push(macro {
						tag: ${tag},
						attrs: ${createAttrsExpr(data)},
						children: (${createExpr(item.children, data.content)}: Dynamic)
					});
				case Block.ExprBlock(e, _):
					exprList.push(e);
				case Block.CustomElement(name, arguments, _):
					var t = {
						sub: null, params: null, pack: [], name: name
					};
					exprList.push(macro {
						(new $t()).view($a{arguments});
					});
			}
		}
		return macro ($a{exprList}: Dynamic);
	}
	
	static function createAttrsExpr(data: Element): Expr {
		var e: Expr;
		var id = data.selector.id;
		var className = data.selector.classes.join(' ');
		
		var fields: Array<ObjField> = [];
		
		if (data.attributes != null) {
			switch (data.attributes) {
				case _.expr => ExprDef.EObjectDecl(f):
					fields = f;
				case macro {}:
				default:
					// concat objects
					var attrs: Array<Expr> = [];
					if (id != '')
						attrs.push(macro Reflect.setField(t, 'id', $v { id } ));
					if (className != '')
						attrs.push(macro Reflect.setField(t, 'class', $v{className}));
					for (attr in data.inlineAttributes) {
						var key = attr.attr;
						attrs.push(macro Reflect.setField(t, $v{key}, ${attr.value}));
					}
					if (attrs.length > 0)
						return macro {
							var t = ${data.attributes};
							$b{attrs};
							t;
						};
					else 
						return data.attributes;
			}
		}
		
		if (id != '')
			addToObjFields(fields, 'id', macro $v{id});
		if (className != '')
			addToObjFields(fields, 'class', macro $v{className});
		for (attr in data.inlineAttributes) {
			addToObjFields(fields, attr.attr, attr.value);
		}
		return {
			expr: ExprDef.EObjectDecl(fields), pos: Context.currentPos()
		};
	}
	
	static function addToObjFields(fields: Array<ObjField>, key: String, expr: Expr) {
		var exists = false;
		fields.map(function(field: ObjField) {
			if (field.field == key) {
				exists = true;
				field.expr = expr;
			}
		});
		if (!exists) {
			fields.push({
				field: key,
				expr: expr
			});
		}
	}
	
	static function orderBlocks(ctx: ViewContext) {
		ctx.blocks.reverse();
		var list: Array<BlockWithChildren> = [];
		var current: BlockWithChildren = null;
		for (block in ctx.blocks) {
			var line = switch (block) {
				case Block.ElementBlock(_, pos) | Block.ExprBlock(_, pos) | Block.CustomElement(_, _, pos):
					pos.line;
			}
			var indent = lines.get(line);
			var addTo: BlockWithChildren = current;
			
			if (addTo != null) {
				if (indent == current.indent) {
						addTo = current.parent;
				} else if (indent < current.indent) {
					var parent = current.parent;
					while (parent != null && indent <= parent.indent) {
						parent = parent.parent;
					}
					addTo = parent;
				}
			}
			
			var positionedBlock = {
				block: block,
				children: [],
				indent: indent,
				line: line,
				parent: addTo
			};
			
			current = positionedBlock;
			
			if (addTo != null)
				addTo.children.push(positionedBlock);
			else
				list.push(positionedBlock);
		}
		return list;
	}
	
	static function element(): Element {
		return {
			selector: {
				tag: '',
				classes: [],
				id: '',
			},
			attributes: null,
			inlineAttributes: [],
			content: null
		};
	}
	
	static function chainElement(params: Array<Expr>, callExpr: Expr): Null<Block> {
		if (params.length == 0 || params.length > 3) 
			return null;
						
		var element = element();
		var e = params[0];
		switch (e.expr) {
			case ExprDef.EConst(c):
				switch (c) {
					case Constant.CIdent(s):
						if (s.charAt(0) == s.charAt(0).toUpperCase()) {
							// Custom element
							return Block.CustomElement(s, params.slice(1), posInfo(e));
						} else {
							element.selector.tag = s;
						}
					default: return null;
				}
			case ExprDef.EField(_, _) | ExprDef.EBinop(_, _, _) | ExprDef.EArray(_, _):
				getAttr(e, element.inlineAttributes);
				removeAttr(e);
				element.selector = parseSelector(e.toString().replace(' ', ''));
			default: return null;
		}
		
		if (params.length > 1)
			element.attributes = params[1];
		if (params.length > 2)
			element.content = params[2];
			
		return Block.ElementBlock(element, posInfo(e));
	}
	
	static function removeAttr(e: Expr) {
		switch (e.expr) {
			case ExprDef.EArray(e1, _):
				removeAttr(e1);
				e.expr = e1.expr;
			default:
		}
		e.iter(removeAttr);
	}
	
	static function getAttr(e: Expr, attributes: Array<InlineAttribute>) {
		switch (e.expr) {
			case ExprDef.EArray(prev, _ => macro $a=$b):
				switch (a.expr) {
					case ExprDef.EConst(_ => Constant.CIdent(s)):
						attributes.push({
							attr: s,
							value: b
						});
					default:
				}
			case ExprDef.EArray(prev, _ => macro $a):
				switch (a.expr) {
					case ExprDef.EConst(_ => Constant.CIdent(s)):
						attributes.push({
							attr: s,
							value: macro true
						});
					default:
				}
			default:
		}
		e.iter(getAttr.bind(_, attributes));
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
	
	static function posInfo(e: Expr): PosInfo {
		var pos = e.pos;
		var info = Std.string(pos);
		var check = ~/([0-9]+): characters ([0-9]+)-([0-9]+)/;
		check.match(info);
		var line = 0;
		var start = 0;
		var end = 0;
		try {
			line = Std.parseInt(check.matched(1));
			start = Std.parseInt(check.matched(2));
			end = Std.parseInt(check.matched(3));
		} catch (error: Dynamic) {
			var subs = [];
			e.iter(function(e) {
				subs.push(e);
			});
			if (subs.length > 0) {
				return posInfo(subs[subs.length-1]);
			}
		}

		if (!lines.exists(line) || lines.get(line) > start)
			lines.set(line, start);
		
		return {
			file: Context.getPosInfos(pos).file,
			line: line,
			start: start,
			end: end
		};
	}
	#end
}