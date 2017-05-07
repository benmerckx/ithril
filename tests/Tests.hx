import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import ithril.Component;
import ithril.Vnode;
import ithril.IthrilView;
import ithril.HTMLRenderer;
import haxe.Json;

class CustomElement extends Component {
	override public function view(vnode:Vnode):Vnode [
		(div (vnode.attrs))
	];
}

class CombinedAttributes extends Component {
	override public function view(vnode:Vnode):Vnode [
		(div (vnode.attrs))
	];
}

class ListComponent extends Component {
    override public function view(vnode:Vnode):Vnode [
			(ul)
				(vnode.children => child)
					(li)
						[@:vnode child]
    ];
}

class Label extends Component {
	var msg:String;
	override public function oninit(vnode:Vnode) {
		msg = vnode.attrs.msg;
	}

	override public function view(vnode:Vnode) [
		(div > msg)
	];
}

class TestHTMLRenderer extends TestCase implements IthrilView {
	
	public function testBasic() {
		assertEquals('<div></div>', HTMLRenderer.render([(div)]));
	}
	
	public function testAttributes() {
		assertEquals('<div attr="test"></div>', HTMLRenderer.render([(div (attr = 'test'))]));
		assertEquals('<div attr="123"></div>', HTMLRenderer.render([(div (attr = 123))]));
	}
	
	public function testStyleAttribute() {
		assertEquals('<div style="param2:test;param:value"></div>', HTMLRenderer.render([(div (style = {param: 'value', param2: 'test'}))]));
		assertEquals('<div style="param:value"></div>', HTMLRenderer.render([(div (style = 'param:value'))]));
		assertEquals('<div style="background-color:white"></div>', HTMLRenderer.render([(div (style = {backgroundColor: 'white'}))]));
	}
	
	public function testChildren() {
		assertEquals('<div><div></div><div><div></div></div></div>', HTMLRenderer.render([
			(div)
				(div)
				(div)
					(div)
		]));
	}
	
	public function testSvg() {
		assertEquals('<svg xmlns="http://www.w3.org/2000/svg"><a xlink:href="http://example.com/link/"><text x="10" y="25">Link</text></a></svg>', 
			HTMLRenderer.render([
				(svg)
					(a (href="http://example.com/link/"))
						(text (x="10", y="25") > 'Link')
			])
		);
	}
	
	public function testTextnode() {
		assertEquals('<div>Test</div>', HTMLRenderer.render([(div > 'Test')]));
	}
	
	public function testEscape() {
		assertEquals('<div attr="&lt;" style="param:&lt;">&lt;</div>', HTMLRenderer.render([(div (attr = '<', style = {param: '<'}) > '<')]));
	}
	
	public function testCustomList() {
		var html =
				HTMLRenderer.render([
						(ListComponent)
							(span > 'A')
							(span > 'B')
							(span > 'C')
		]);
		assertEquals('<ul><li><span>A</span></li><li><span>B</span></li><li><span>C</span></li></ul>', html);
	}
	
	public function testCustomLabel() {
		assertEquals('<div>ok</div>', HTMLRenderer.render([
			(Label (msg='ok'))
		]));
		function ok() return 'ok';
		assertEquals('<div>ok</div>', HTMLRenderer.render([
			(Label (msg=ok))
		]));
		var variable = 'ok';
		assertEquals('<div>ok</div>', HTMLRenderer.render([
			(Label (msg=variable))
		]));
	}
	
	public function testTrusted() {
		assertEquals('&lt;b&gt;ok&lt;/b&gt;', HTMLRenderer.render([
			['<b>ok</b>']
		]));
		assertEquals('<div><b>ok</b></div>', HTMLRenderer.render([ 
			(div) 
				[@:trust '<b>ok</b>']
		]));
	}
}

class TestIthil extends TestCase implements IthrilView {
	
	public function testBasic() {
		assert({tag: 'div', attrs: {}, children: []}, [(div)]);
	}
	
	public function testClassname() {
		assert({tag: 'div', attrs: {'class': 'test'}, children: []}, [(div.test)]);
		assert({tag: 'div', attrs: {'class': 'test second'}, children: []}, [(div.test.second)]);
		assert({tag: 'div', attrs: {'class': 'test-with-hyphen'}, children: []}, [(div.test-with-hyphen)]);
		assert({tag: 'div', attrs: {'class': ['c1', 'c2']}, children: []}, [(div ('class' = ['c1', 'c2']))]);
	}
	
	/**
	 * From mithril docs:
	 * For developer convenience, Mithril makes an exception for the class attribute: 
	 * if there are classes defined in both parameters, they are concatenated as a space separated list. 
	 * It does not, however, de-dupe classes if the same class is declared twice.
	 */
	public function testClassnameCombine() {		
		assert({tag: 'div', attrs: {'class': 'test test2'}, children: []}, [(div.test ('class' = 'test2'))]);
		assert({tag: 'div', attrs: {'class': 'test test2'}, children: []}, [(div.test ('class' = ['test2']))]);
		assert({tag: 'div', attrs: {'class': 'test test2'}, children: []}, [(div ('class' = 'test') ('class' = 'test2'))]);
	}
	
	public function testId() {
		assert({tag: 'div', attrs: {'id': 'test'}, children: []}, [(div+test)]);
		assert({tag: 'div', attrs: {'id': 'test-with-hyphen'}, children: []}, [(div+test-with-hyphen)]);
	}
	
	public function testChildren() {
		assert({tag: 'div', attrs: {}, children: [{tag: 'div', attrs: {}, children: []}]}, [
			(div)
				(div)
		]);
		
		assert({tag: 'div', attrs: {}, children: [{tag: 'div', attrs: {}, children: [{tag: 'div', attrs: {}, children: []}]}]}, [
			(div)
				(div)
					(div)
		]);
		
		assert({tag: 'div', attrs: {}, children: [{tag: 'div', attrs: {}, children: []}, {tag: 'div', attrs: {}, children: []}]}, [
			(div)
				(div)(div)
		]);
		
		assert({tag: 'div', attrs: {}, children: [{tag: 'div', attrs: {}, children: []}, {tag: 'div', attrs: {}, children: []}]}, [
			(div)
				(div)
				(div)
		]);
		
		assert(([{tag: 'div', attrs: {}, children: [{tag: 'div', attrs: {}, children: []}]}, {tag: 'div', attrs: {}, children: []}]: Dynamic), [
			(div)
				(div)
			(div)
		]);
	}
	
	public function testAttribute() {
		assert({tag: 'div', attrs: {attr: 'test'}, children: []}, [(div[attr='test'])]);
		assert({tag: 'div', attrs: {attr: 'test', second: 'test'}, children: []}, [(div[attr='test'][second='test'])]);
	}
	
	public function testCallableAttribute() {
		function attr(): {attr:String} return {
			attr: 'test'
		}
		assert({tag: 'div', attrs: {attr: 'test'}, children: []}, [(div (attr))]);
	}
	
	public function testCombineAttributes() {
		assert({tag: 'div', attrs: {a: 1, b: 2}, children: []}, [
			(div (a=1) (b=2))
		]);
		assert({tag: 'div', attrs: {a: 1}, children: []}, [
			(div (a=1) (a=2))
		]);
		function attr() return {
			attr: 'test'
		}
		assert({tag: 'div', attrs: {a: 1, attr: 'test'}, children: []}, [
			(div (a=1) (attr))
		]);
		assert({tag: 'div', attrs: {id: 'id', a: 1, attr: 'test'}, children: [ ], text: 'ok' }, [
			(div+id (a=1) (attr) > 'ok')
		]);
	}
	
	public function testCombination() {
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test'}, children: []}, [(div[attr='test'].test+test)]);
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test'}, children: [], text: 'a' }, [(div[attr='test'].test+test > 'a')]);
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test', attr2: 'test'}, children: []}, [(div[attr='test'].test+test[attr2='test'])]);
	}
	
	public function testTextnode() {
		assert({tag: 'div', attrs: {}, children: [ ], text: 'Test'}, [(div > 'Test')]);
	}
	
	public function testAddToExistingAttributes() {
		var expected = {tag: 'div', attrs: {attr: 'test', id: 'test', 'class': 'test'}, children: []};
		assert(expected, [(div.test+test (attr ='test'))]);
		assert(expected, [(div.test+test  
			((function(): Dynamic {
				return {
					attr: 'test'
				}
			})())
		)]);
	}
	
	public function testInlineExpression() {
		assert({tag: 'div', attrs: {}, children: [], text: 'Test'}, [
			(div)
				['Test']
		]);
	}
	
	public function testInlineLoops() {
		var items = ['a', 'b', 'c'];
		assert({tag: 'div', attrs: {}, children: ([ { 'tag': '[', children: items } ]:Array<Dynamic>) }, [
			(div)
				($for (i in items))
					[i]
		]);
		assert({tag: 'div', attrs: {}, children: [ { 'tag': '[', children: items } ] }, [
			(div)
				(i in items)
					[i]
		]);
		assert({tag: 'div', attrs: {}, children: [], text: '[a,b,c]' }, [
			(div)
				[for (i in items) i]
		]);
		assert({tag: 'div', attrs: {}, text: '[a,b,c]', children: ([ {tag: 'div', attrs: {}, children: []}]: Array<Dynamic>)}, [
			(div)
				[for (i in items) i]
				(div)
		]);
	}
	
	public function testCustomElement() {
		assert({tag: 'div', attrs: {attr: 'test'}, children: []}, new CustomElement().view({ tag: '', attrs: { attr: 'test' } }));
			//[(CustomElement (attr = 'test'))].view(null)
		//);
	}
	
	public function testCustomElementKeepRef() {
		var test = null;
		var html = HTMLRenderer.render([(test = CustomElement (attr = 'test'))]);
		assertEquals(true, test != null);
	}
	
	public function testCustomCombined() {
		var html = HTMLRenderer.render([(CombinedAttributes (a=1) (b=2))]);
		assert('<div a="1" b="2"></div>', html);
	}
	
	inline function assert<T>(o1: T, o2: T) {
		assertEquals(Json.stringify(o1, null, ' '), Json.stringify(o2, null, ' '));
	}
	
}

class Tests {
	public static function main() {
		var runner = new TestRunner();
		runner.add(new TestIthil());
		runner.add(new TestHTMLRenderer());
		runner.run();
	}
}
