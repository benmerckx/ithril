import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import ithril.Component;
import ithril.Ithril;
import ithril.HTMLRenderer;
import haxe.Json;

class CustomElement extends Component<{attr: String}> {
	public function view() [
		(div (state))
	];
}

class CombinedAttributes extends Component<{a: Int, b: Int}> {
	public function view() [
		(div (state))
	];
}

class ListComponent extends Component {
    public function view() [
        (ul)
            (children => child)
                (li > child)
    ];
}

class Label extends Component<String> {
	public function view() [
		(div > state)
	];
}

class TestHTMLRenderer extends TestCase implements Ithril {
	
	public function testBasic() {
		assertEquals('<div></div>', HTMLRenderer.render([(div)]));
	}
	
	public function testAttributes() {
		assertEquals('<div attr="test"></div>', HTMLRenderer.render([(div (attr = 'test'))]));
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
	
	public function testTextnode() {
		assertEquals('<div>Test</div>', HTMLRenderer.render([(div > 'Test')]));
	}
	
	public function testEscape() {
		assertEquals('<div attr="&lt;" style="param:&lt;">&lt;</div>', HTMLRenderer.render([(div (attr = '<', style = {param: '<'}) > '<')]));
	}
	
	public function testCustomList() {
		assertEquals('<ul><li><span>A</span></li><li><span>B</span></li><li><span>C</span></li></ul>', HTMLRenderer.render([
			(ListComponent)
				(span > 'A')
				(span > 'B')
				(span > 'C')
		]));
	}
	
	public function testCustomLabel() {
		assertEquals('<div>ok</div>', HTMLRenderer.render([
			(Label ('ok'))
		]));
		function ok() return 'ok';
		assertEquals('<div>ok</div>', HTMLRenderer.render([
			(Label (ok))
		]));
		var variable = 'ok';
		assertEquals('<div>ok</div>', HTMLRenderer.render([
			(Label (variable))
		]));
	}
}

class TestIthil extends TestCase implements Ithril {
	
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
		assert({tag: 'div', attrs: {id: 'id', a: 1, attr: 'test'}, children: ['ok']}, [
			(div+id (a=1) (attr) > 'ok')
		]);
	}
	
	public function testCombination() {
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test'}, children: []}, [(div[attr='test'].test+test)]);
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test'}, children: ['a']}, [(div[attr='test'].test+test > 'a')]);
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test', attr2: 'test'}, children: []}, [(div[attr='test'].test+test[attr2='test'])]);
	}
	
	public function testTextnode() {
		assert({tag: 'div', attrs: {}, children: ['Test']}, [(div > 'Test')]);
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
		assert({tag: 'div', attrs: {}, children: ['Test']}, [
			(div)
				['Test']
		]);
	}
	
	public function testInlineLoops() {
		var items = ['a', 'b', 'c'];
		assert({tag: 'div', attrs: {}, children: items}, [
			(div)
				($for (i in items))
					[i]
		]);
		assert({tag: 'div', attrs: {}, children: items}, [
			(div)
				(i in items)
					[i]
		]);
		assert({tag: 'div', attrs: {}, children: [items]}, [
			(div)
				[for (i in items) i]
		]);
		assert({tag: 'div', attrs: {}, children: ([items, {tag: 'div', attrs: {}, children: []}]: Array<Dynamic>)}, [
			(div)
				[for (i in items) i]
				(div)
		]);
	}
	
	public function testCustomElement() {
		assert({tag: 'div', attrs: {attr: 'test'}, children: []}, 
			[(CustomElement (attr = 'test'))].view()
		);
	}
	
	public function testCustomCombined() {
		assert({tag: 'div', attrs: {a: 1, b: 2}, children: []}, 
			[(CombinedAttributes (a=1) (b=2))].view()
		);
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