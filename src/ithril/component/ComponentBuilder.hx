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
          if (params.length > 0)
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

  static function stateFields(param: Type): Array<String> {
    switch (param) {
      case TAnonymous(_.get() => (a = _)):
        return a.fields.map(function(field) {
          return field.name;
        });
      default:
        return [];
    }
  }

  static public function build() {
    var fields = Context.getBuildFields();
    if (params.length > 0) {
      var stateType = Context.follow(params[0]);
  	  var fieldNames = stateFields(stateType);
      fields.map(function(field) {
        if (field.name == 'stateFields') {
          field.kind = FVar(macro: Array<String>, macro $v{fieldNames});
        }
      });
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
