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
    var state = (macro: {});
    var children = (macro: Dynamic);
    switch (Context.getLocalType()) {
      case TInst(cl, paramList):
          params = paramList;
          if (params.length == 1)
            state = TypeTools.toComplexType(params[0]);
          if (params.length > 1)
            children = TypeTools.toComplexType(params[1]);
      default:
        Context.error("Class expected", Context.currentPos());
    }
    return ComplexType.TPath({
      sub: 'ComponentAbstract',
      params: [TPType(state), TPType(children)],
      pack: ['ithril'],
      name: 'Component'
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
    if (params.length > 0) {
      var stateType = Context.follow(params[0]);
  	  var extra = buildFields(stateType);
  	  extra.map(function(field) {
    		if (!fields.exists(function(f) return f.name == field.name)) {
    		  fields.push(field);
    		}
  	  });
      //fields = fields.concat(buildFields(Context.follow(params[0])));
    }
    fields.map(function(field) {
      if (field.name == 'view' || field.name == 'controller' || field.name == 'setState' || field.name == 'setChildren') {
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
