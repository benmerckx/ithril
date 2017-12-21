package ithril;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.crypto.Md5;

using StringTools;
using tink.MacroApi;
using tink.CoreApi;

typedef Cell = {
	tag: String,
	attrs: Dynamic,
	children: Dynamic
}

enum Block {
	ElementBlock(data: Element, pos: PosInfo);
	ExprBlock(e: Expr, pos: PosInfo);
	CustomElement(type: String, arguments: Array<Expr>, pos: PosInfo);
	For(e: Expr, pos: PosInfo);
	If(e: Expr, pos: PosInfo);
	Else(pos: PosInfo);
	Map(a: Expr, b: Expr, pos: PosInfo);
	Assignment(ident: String, block: Block, pos: PosInfo);
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
	end: Int,
	pos: Position
}

typedef InlineAttribute = {
	attr: String,
	value: Expr
}

typedef ObjField = 
	#if (haxe_ver >= 4) haxe.macro.ObjectField;
	#else {field : String, expr : Expr} #end

typedef Lines = Map<Int, Int>;

class IthrilBuilder {

	static var lines: Lines;
	static var isTemplate: Bool;

	macro static public function build(): Array<Field>
		return Context.getBuildFields().map(inlineView);

	static function inlineView(field: Field)
		return switch field.kind {
			case FieldType.FFun(func):
				lines = new Lines();
				isTemplate = false;
				parseFunction(func.expr);
				if (isTemplate) {
					func.expr = yieldExpr(func.expr);
					yieldSubExpr(func.expr);
				}
				field;
			default: field;
		}
		
	static function yieldSubExpr(e: Expr) {
		switch e {
			case macro function($a) $b:
				e.expr = (macro function($a) ${yieldExpr(b)}).expr;
			default:
		}
		e.iter(yieldSubExpr);
	}
	
	static function yieldExpr(e: Expr)
		return e.yield(function(e) {
			return switch e {
				case macro (@:ithril $f: Dynamic):
					macro return ($f: Dynamic);
				default: e;
			}
		});
		
	static function parseFunction(e: Expr) {
		switch e.expr {
			case ExprDef.EArrayDecl(values):
				if (values.length == 1)
					switch parseCalls(values[0]) {
						case Success(blocks):
							isTemplate = true;
							e.expr = createExpr(orderBlocks(blocks), true).expr;
						default:
					}
			default:
		}
		e.iter(parseFunction);
	}

	static function parseCalls(e: Expr): Outcome<Array<Block>, Noise>
		return switch e {
			case _.expr => ExprDef.ECall(callExpr, params):
				if (params.length != 1) Failure(Noise);
				else switch chainElement(params[0]) {
					case Success(b1):
						switch parseCalls(callExpr) {
							case Success(b2): Success([b1].concat(b2));
							default: Failure(Noise);
						}
					default: Failure(Noise);
				}
			case macro $e1[$e2]:
				var block = Block.ExprBlock(preprocess(e2), posInfo(e2));
				switch parseCalls(e1) {
					case Success(b): Success([block].concat(b));
					default: Failure(Noise);
				}
			case macro ($start):
				switch chainElement(start) {
					case Success(b): Success([b]);
					default: Failure(Noise);
				}
			default:
				Failure(Noise);
		}

	static function preprocess(e: Expr) return switch e {
		case macro for($head) $body:
			macro @:pos(e.pos) ([for ($head) $body]);
		case macro while($head) $body:
			macro @:pos(e.pos) ([while ($head) $body]);
		default: e;
	}

	static function createExpr(list: Array<BlockWithChildren>, root = false, ?prepend: Expr): Expr {
		var exprList: Array<Expr> = [];
		if (prepend != null) exprList.push(prepend);
		var i = 0;
		for (item in list) {
			switch item.block {
				case Block.For(e, pos):
					root = true;
					exprList.push(macro @:pos(pos.pos) [for ($e) ${createExpr(item.children, true)}]);
				case Block.If(e, pos):
					var elseCond = macro @:pos(pos.pos) null;
					if (list.length > i+1) {
						var next: BlockWithChildren = list[i+1];
						switch next.block {
							case Block.Else(_):
								if (next.indent == item.indent)
									elseCond = createExpr(next.children);
							default:
						}
					}
					//root = true;
					exprList.push(macro @:pos(pos.pos) $e ? ${createExpr(item.children)} : $elseCond);
				case Block.Else(_):
					continue;
				case Block.Map(a, b, pos):
					switch b.getIdent() {
						case Success(i):
							root = true;
							exprList.push(macro @:pos(pos.pos) $a.map(function($i) ${createExpr(item.children, true)}));
						default: continue;
					}
				case Block.ElementBlock(data, pos):
					var tag = Context.makeExpr(data.selector.tag, Context.currentPos());
					exprList.push(macro {
						tag: ${tag},
						attrs: ${createAttrsExpr(pos.pos, data)},
						children: (${createExpr(item.children, false, data.content)}: Dynamic)
					});
				case Block.ExprBlock(e, _):
					exprList.push(e);
				case Block.Assignment(ident, block, pos):
					item.block = block;
					var el = createExpr([item], true);
					exprList.push(macro @:pos(pos.pos) $i{ident} = $el);
				case Block.CustomElement(name, arguments, pos):
					var key = Md5.encode(Std.string(pos));
					var state = arguments.length > 0 ? arguments[0] : macro @:pos(pos.pos) null;
					exprList.push(macro @:pos(pos.pos) {
						var children: Dynamic = ${createExpr(item.children)};
						var tmp =
						ithril.component.ComponentCache.getComponent($v{key}, $i{name}, children, $state);
						tmp.setChildren(children);
						tmp.setState($state);
						if (!@:privateAccess tmp.isMounted) {
							tmp.mount();
							@:privateAccess tmp.isMounted = true;
						}
						tmp;
					});
			}
			i++;
		}
		var pos = exprList.length > 0 ? exprList[0].pos : Context.currentPos();
		
		if (root) {
			var res = exprList.length == 1 ? macro ${exprList[0]} : macro $a{exprList};
			return macro @:pos(pos) (@:ithril $res: Dynamic);
		}
		
		return macro @:pos(pos) ($a{exprList}: Dynamic);
	}

	static function createAttrsExpr(pos: Position, data: Element): Expr {
		var fields: Array<ObjField> = [];
		if (data.attributes != null) {
			switch (data.attributes) {
				case _.expr => ExprDef.EObjectDecl(f):
					fields = f;
				case macro {}:
				default:
					// concat objects
					var e = addFieldsFromElement(data.attributes.pos, fields, data);
					if (fields.length > 0)
						return macro @:pos(e.pos) ithril.Attributes.combine($e, ${data.attributes});
					else
						return data.attributes;
			}
		}
		return addFieldsFromElement(pos, fields, data);
	}
	
	static function addFieldsFromElement(pos: Position, fields: Array<ObjField>, data: Element) {
		var id = data.selector.id;
		var className = data.selector.classes.join(' ');
		if (id != '')
			addToObjFields(fields, 'id', macro $v{id});
		if (className != '')
			addToObjFields(fields, 'class', macro $v{className});
		for (attr in data.inlineAttributes) {
			addToObjFields(fields, attr.attr, attr.value);
		}
		return {
			expr: ExprDef.EObjectDecl(fields), pos: pos
		};
	}

	static function addToObjFields(fields: Array<ObjField>, key: String, expr: Expr) {
		var exists = false;
		fields.map(function(field: ObjField) {
			if (field.field == key) {
				exists = true;
				if (key == 'class')
					field.expr = macro @:pos(expr.pos) ithril.Attributes.combineClassNames(${field.expr}, $expr);
				else
					field.expr.expr = expr.expr;
			}
		});
		if (!exists) {
			fields.push({
				field: key,
				expr: expr
			});
		}
	}

	static function orderBlocks(blocks: Array<Block>) {
		blocks.reverse();
		var list: Array<BlockWithChildren> = [];
		var current: BlockWithChildren = null;
		for (block in blocks) {
			var line = switch (block) {
				case Block.ElementBlock(_, pos) | 
					 Block.ExprBlock(_, pos) | 
					 Block.CustomElement(_, _, pos) | 
					 Block.For(_, pos) |
					 Block.If(_, pos) |
					 Block.Map(_, _, pos) |
					 Block.Assignment(_, _, pos) |
					 Block.Else(pos):
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

	static function chainElement(e: Expr): Outcome<Block, Noise> {
		var element = element();
		switch e {
			case macro $f ($a) if (f.getIdent().equals("$for")):
				return Success(Block.For(a, posInfo(e)));
			case macro $a in $b:
				return Success(Block.For(e, posInfo(e)));
			case macro $f ($a) if (f.getIdent().equals("$if")):
				return Success(Block.If(a, posInfo(e)));
			case macro $f if (f.getIdent().equals("$else")):
				return Success(Block.Else(posInfo(e)));
			case macro $a => $b:
				return Success(Block.Map(a, b, posInfo(e)));
			case macro !doctype:
				element.selector.tag = '!doctype';
				element.attributes = macro {html: true};
			case macro $v = $el:
				switch chainElement(el) {
					case Success(block): 
						switch block {
							case Block.CustomElement(_, _, pos):
								switch v.getIdent() {
									case Success(ident):
										return Success(Block.Assignment(ident, block, posInfo(v)));
									default:
								}
							default:
						}
					default:
				}
				return Failure(Noise);
			case _.expr => ExprDef.EConst(c):
				switch (c) {
					case Constant.CIdent(s):
						if (s.charAt(0) == s.charAt(0).toUpperCase()) {
							// Custom element
							return Success(Block.CustomElement(s, [], posInfo(e)));
						} else {
							element.selector.tag = s;
						}
					default: return Failure(Noise);
				}
			case _.expr => ExprDef.EBinop(op, e1, e2):
				switch op {
					case Binop.OpAdd | Binop.OpSub:
						switch chainElement(e2) {
							case Success(Block.ElementBlock(el, _)):
								element.attributes = el.attributes;
							default:
						}
						parseEndBlock(e, element);
					case Binop.OpGt:
						switch chainElement(e1) {
							case Success(block):
								switch block {
									case Block.ElementBlock(el, _):
										element = el;
										element.content = e2;
									default:
										return Failure(Noise);
								}
							default: return Failure(Noise);
						}
					default: 
						return Failure(Noise);
				}
			case _.expr => ExprDef.EField(_, _) | ExprDef.EArray(_, _):
				parseEndBlock(e, element);
			case _.expr => ExprDef.ECall(e1, attrs):
				switch chainElement(e1) {
					case Success(block): 
						switch block {
							case Block.ElementBlock(el, _):
								switch extractAttributes(attrs) {
									case Success(a): 
										if (el.attributes != null)
											el.attributes = macro @:pos(a.pos) ithril.Attributes.combine(${el.attributes}, $a);
										else
											el.attributes = a;
									case Failure(Noise): return Failure(Noise);
								}
							case Block.CustomElement(type, prevAttr, pos):
								switch extractAttributes(attrs) {
									case Success(a): {
										if (prevAttr != null && prevAttr.length != 0) {
											a = macro @:pos(a.pos) ithril.Attributes.combine(${prevAttr[0]}, $a);
										}
										return Success(Block.CustomElement(type, [a], pos));
									}
									case Failure(Noise): return Failure(Noise);
								}
							default:
						}
						return Success(block);
					case Failure(Noise): return Failure(Noise);
				}
			default: return Failure(Noise);
		}

		return Success(Block.ElementBlock(element, posInfo(e)));
	}
	
	static function parseEndBlock(e, element) {
		getAttr(e, element.inlineAttributes);
		var clean = {expr: e.expr, pos: e.pos};
		removeAttr(clean);
		element.selector = parseSelector(clean.toString().replace(' ', ''));
	}
	
	static function extractAttributes(attrs: Array<Expr>): Outcome<Expr, Noise> {
		if (attrs.length == 1)
			switch attrs[0] {
				case macro $a=$b:
					switch assignToField(a, b) {
						case Success(field): 
							return Success({expr: ExprDef.EObjectDecl([field]), pos: a.pos});
						default: Failure(Noise);
					}
				default: {
					// Call if is callable
					return Success(macro @:pos(attrs[0].pos) ithril.Attributes.attrs(${attrs[0]}));
				}
			}
			
		var fields = [];
		for (e in attrs) {
			switch e {
				case macro $a=$b:
					switch assignToField(a, b) {
						case Success(field): fields.push(field);
						default: return Failure(Noise);
					}
				default: return Failure(Noise);
			}
		}
		return Success({expr: ExprDef.EObjectDecl(fields), pos: attrs[0].pos});
	}
	
	static function assignToField(a: Expr, b: Expr): Outcome<ObjField, Noise>
		return switch a.getName() {
			case Success(name):
				Success({field: name, expr: b});
			default: Failure(Noise);
		}

	static function removeAttr(e: Expr) {
		switch (e.expr) {
			case ExprDef.EArray(e1, _):
				removeAttr(e1);
				e.expr = e1.expr;
			case ExprDef.ECall(e1, _):
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
			end: end,
			pos: pos
		};
	}
}
