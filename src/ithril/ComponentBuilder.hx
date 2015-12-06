package ithril;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

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
          meta: null,
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
    return fields;
  }
}
