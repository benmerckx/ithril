package ithril;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

using Lambda;

@:access(haxe.macro.TypeTools)
class ComponentBuilder {
  static var params: Array<Type>;

  static public function buildGeneric() {
    switch (Context.getLocalType()) {
      case TInst(cl, paramList):
        params = paramList;
        if (paramList.length > 1)
          Context.error("ithril.Component can have no more than one type parameter", Context.currentPos());
      default:
        Context.error("Class expected", Context.currentPos());
    }
    return ComplexType.TPath({
      sub: null,
      params: null,
      pack: ['ithril'],
      name: 'ComponentAbstract'
    });
  }

  static function buildFields(param: Type) {
    switch (param) {
      case TAnonymous(_.get() => (a = _)):
        var fields = a.fields.map(TypeTools.toField);
        var setters = a.fields.map(function(field) {
          return macro {$p{['this', field.name]} = $i{field.name};};
        });
        fields.push({
          pos: Context.currentPos(),
          name: 'setState',
          meta: [{
            pos: Context.currentPos(),
            params: null,
            name: ':keep'
          }],
          kind: FFun({
            ret: TPath({sub: null, name: "Void", pack:[], params:[]}),
            params: null,
            expr: macro $b{setters},
            args: a.fields.map(function(field) return {
              value: null,
              type: TypeTools.toComplexType(field.type),
              opt: false,
              name: field.name
            })
          }),
          doc: null,
          access: [APublic]
        });
        return fields;
      default:
        return [];
    }
  }

  static public function build() {
    var fields = Context.getBuildFields();
    if (params.length == 1) {
      fields = fields.concat(buildFields(Context.follow(params[0])));
    }
    fields.map(function(field) {
      if (field.name == 'view' || field.name == 'controller') {
        field.meta = field.meta == null ? [] : field.meta;
        field.meta.push({
          pos: Context.currentPos(),
          params: null,
          name: ':keep'
        });
      }
    });
    if (!fields.exists(function(field) return field.name == 'children')) {
      fields.push({
        pos: Context.currentPos(),
        name: 'children',
        meta: null,
        kind: FVar(macro : Array<ithril.VirtualElement>)
      });
    }
    if (!fields.exists(function(field) return field.name == 'parent')) {
      fields.push({
        pos: Context.currentPos(),
        name: 'parent',
        meta: null,
        kind: FVar(macro : ithril.VirtualElement)
      });
    }
    return fields;
  }
}
