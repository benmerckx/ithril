import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import ithril.Component;
import ithril.Vnode;
import ithril.View;
import ithril.HTMLRenderer;
import haxe.Json;

class CustomElement extends Component {
	override public function view(vnode:Vnode):Vnode @m[
		(div (vnode.attrs))
	];
}

class CombinedAttributes extends Component {
	override public function view(vnode:Vnode):Vnode @m[
		(div (vnode.attrs))
	];
}

class ListComponent extends Component {
    override public function view(vnode:Vnode):Vnode @m[
			(ul)
				(vnode.children => child)
					(li)
						[child]
    ];
}

class Label extends Component {
	var msg:String;
	override public function oninit(vnode:Vnode) {
		msg = vnode.attrs.msg;
	}

	override public function view(vnode:Vnode) @m[
		(div > msg)
	];
}

class TestHTMLRenderer extends TestCase implements View {

	public function testBasic() {
		assertEquals('<div></div>', HTMLRenderer.render(@m[(div)]));
	}

	public function testAttributes() {
		assertEquals('<div attr="test"></div>', HTMLRenderer.render(@m[(div (attr = 'test'))]));
		assertEquals('<div attr="123"></div>', HTMLRenderer.render(@m[(div (attr = 123))]));
	}

	public function testStyleAttribute() {
		assertEquals('<div style="param2:test;param:value"></div>', HTMLRenderer.render(@m[(div (style = {param: 'value', param2: 'test'}))]));
		assertEquals('<div style="param:value"></div>', HTMLRenderer.render(@m[(div (style = 'param:value'))]));
		assertEquals('<div style="background-color:white"></div>', HTMLRenderer.render(@m[(div (style = {backgroundColor: 'white'}))]));
	}

	public function testChildren() {
		assertEquals('<div><div></div><div><div></div></div></div>', HTMLRenderer.render(@m[
			(div)
				(div)
				(div)
					(div)
		]));
	}

	public function testSvg() {
		assertEquals('<svg xmlns="http://www.w3.org/2000/svg"><a xlink:href="http://example.com/link/"><text x="10" y="25">Link</text></a></svg>',
			HTMLRenderer.render(@m[
				(svg)
					(a (href="http://example.com/link/"))
						(text (x="10", y="25") > 'Link')
			])
		);
	}

	public function testTextnode() {
		assertEquals('<div>Test</div>', HTMLRenderer.render(@m[(div > 'Test')]));
	}

	public function testEscape() {
		assertEquals('<div attr="&lt;" style="param:&lt;">&lt;</div>', HTMLRenderer.render(@m[(div (attr = '<', style = {param: '<'}) > '<')]));
	}

	public function testCustomList() {
		var html =
				HTMLRenderer.render(@m[
						(ListComponent)
							(span > 'A')
							(span > 'B')
							(span > 'C')
		]);
		assertEquals('<ul><li><span>A</span></li><li><span>B</span></li><li><span>C</span></li></ul>', html);
	}

	public function testCustomLabel() {
		assertEquals('<div>ok</div>', HTMLRenderer.render(@m[
			(Label (msg='ok'))
		]));
		function ok() return 'ok';
		assertEquals('<div>ok</div>', HTMLRenderer.render(@m[
			(Label (msg=ok()))
		]));
		var variable = 'ok';
		assertEquals('<div>ok</div>', HTMLRenderer.render(@m[
			(Label (msg=variable))
		]));
	}

	public function testTrusted() {
		assertEquals('&lt;b&gt;ok&lt;/b&gt;', HTMLRenderer.render(@m[
			['<b>ok</b>']
		]));
		assertEquals('<div><b>ok</b></div>', HTMLRenderer.render(@m[
			(div)
				[@trust '<b>ok</b>']
		]));
	}
}

class TestIthil extends TestCase implements View {

	public function testBasic() {
		assert({tag: 'div', attrs: {}}, @m[(div)]);
	}

	public function testClassname() {
		assert({tag: 'div', attrs: {'class': 'test'}}, @m[(div.test)]);
		assert({tag: 'div', attrs: {'class': 'test second'}}, @m[(div.test.second)]);
		assert({tag: 'div', attrs: {'class': 'test-with-hyphen'}}, @m[(div.test-with-hyphen)]);
		assert({tag: 'div', attrs: {'class': ['c1', 'c2']}}, @m[(div ('class' = ['c1', 'c2']))]);
	}

	/**
	 * From mithril docs:
	 * For developer convenience, Mithril makes an exception for the class attribute:
	 * if there are classes defined in both parameters, they are concatenated as a space separated list.
	 * It does not, however, de-dupe classes if the same class is declared twice.
	 */
	public function testClassnameCombine() {
		assert({tag: 'div', attrs: {'class': 'test test2'}}, @m[(div.test ('class' = 'test2'))]);
		assert({tag: 'div', attrs: {'class': 'test test2'}}, @m[(div.test ('class' = ['test2']))]);
		assert({tag: 'div', attrs: {'class': 'test test2'}}, @m[(div ('class' = 'test') ('class' = 'test2'))]);
	}

	public function testId() {
		assert({tag: 'div', attrs: {'id': 'test'}}, @m[(div+test)]);
		assert({tag: 'div', attrs: {'id': 'test-with-hyphen'}}, @m[(div+test-with-hyphen)]);
	}

	public function testChildren() {
		assert({tag: 'div', children: [{tag: 'div', attrs: {}}]}, @m[
			(div)
				(div)
		]);

		assert({tag: 'div', children: [{tag: 'div', children: [{tag: 'div', attrs: {}}]}]}, @m[
			(div)
				(div)
					(div)
		]);

		assert({tag: 'div', children: [{tag: 'div', attrs: {}}, {tag: 'div', attrs: {}}]}, @m[
			(div)
				(div)(div)
		]);

		assert({tag: 'div', children: [{tag: 'div', attrs: {}}, {tag: 'div', attrs: {}}]}, @m[
			(div)
				(div)
				(div)
		]);

		assert(([ { "children": [ { "tag": "div", "attrs": {} } ], "tag": "div" }, { "tag": "div", "attrs": {} } ]: Dynamic), @m[
				(div)
					(div)
				(div)
		]);
	}

	public function testAttribute() {
		assert({tag: 'div', attrs: {attr: 'test'}}, @m[(div[attr='test'])]);
		assert({tag: 'div', attrs: {attr: 'test', second: 'test'}}, @m[(div[attr='test'][second='test'])]);
	}

	public function testCallableAttribute() {
		function attr(): {attr:String} return {
			attr: 'test'
		}
		assert({tag: 'div', attrs: {attr: 'test'}}, @m[(div (attr))]);
	}

	public function testCombineAttributes() {
		assert({tag: 'div', attrs: {a: 1, b: 2}}, @m[
			(div (a=1) (b=2))
		]);
		assert({tag: 'div', attrs: {a: 1}}, @m[
			(div (a=1) (a=2))
		]);
		function attr() return {
			attr: 'test'
		}
		assert({tag: 'div', attrs: {a: 1, attr: 'test'}}, @m[
			(div (a=1) (attr))
		]);
		assert({ "text": "ok", "tag": "div", "attrs": { "attr": "test", "a": 1, "id": "id" } }, @m[
			(div+id (a=1) (attr) > 'ok')
		]);
	}

	public function testCombination() {
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test'}}, @m[(div[attr='test'].test+test)]);
		assert({ "text": "a", "tag": "div", "attrs": { "attr": "test", "class": "test", "id": "test" } }, @m[(div[attr='test'].test+test > 'a')]);
		assert({tag: 'div', attrs: {'class': 'test', id: 'test', attr: 'test', attr2: 'test'}}, @m[(div[attr='test'].test+test[attr2='test'])]);
	}

	public function testTextnode() {
		assert({
			"text": "Test",
			"tag": "div"
		}, @m[(div > 'Test')]);
	}

	public function testAddToExistingAttributes() {
		var expected = {tag: 'div', attrs: {attr: 'test', id: 'test', 'class': 'test'}};
		assert(expected, @m[(div.test+test (attr ='test'))]);
		assert(expected, @m[(div.test+test
			((function(): Dynamic {
				return {
					attr: 'test'
				}
			})())
		)]);
	}

	public function testInlineExpression() {
		assert({
			"children": [
				"Test"
			],
			"tag": "div"
		}, @m[
			(div)
				['Test']
		]);
	}

	public function testInlineLoops() {
		var items = ['a', 'b', 'c'];
		assert({ "children": [ [ [ "a" ], [ "b" ], [ "c" ] ] ], "tag": "div" }, @m[
			(div)
				($for (i in items))
					[i]
		]);

		assert({ "children": [ [ [ "a" ], [ "b" ], [ "c" ] ] ], "tag": "div" }, @m[
			(div)
				(i in items)
					[i]
		]);

		assert({ "children": [ [ "a", "b", "c" ] ], "tag": "div" }, @m[
			(div)
				[for (i in items) i]
		]);
	}

	public function testCustomElement() {
		assert({tag: 'div', attrs: {attr: 'test'}}, new CustomElement({ }).view({ tag: '', attrs: { attr: 'test' } }));
	}

	public function testCustomElementKeepRef() {
		var test = null;
		var html = HTMLRenderer.render(@m[(test = CustomElement (attr = 'test'))]);
		assertEquals(true, test != null);
	}

	public function testCustomCombined() {
		var html = HTMLRenderer.render(@m[(CombinedAttributes (a=1) (b=2))]);
		assert('<div a="1" b="2"></div>', html);
	}

	public function testIf() {
		var value = 1;
		var rslt = @m[
			($if (value == 1))
				['ok']
			];
		assert(['ok'], rslt);
	}

	public function testIfElse() {
		var value = 1;
		var rslt = @m[
			($if (value == 1))
				['ok']
			($else)
				['not ok']
			];
		assert(['ok'], rslt);
	}

	public function testChainedIfElse() {
		var value = 3;
		var rslt = @m[
			($if (value == 1))
				['ok']
			($elseif (value == 2))
				['2']
			($elseif (value == 3))
				['3']
			($elseif (value == 4))
				['4']
			($else)
				['not ok']
			];
		assert(['3'], rslt);
	}

	public function testNestedChainedIfElse() {
		var value = 4;
		var rslt = @m[
			($if (value == 1))
				['not ok']
			($elseif (value == 2))
				['not ok']
			($elseif (value == 3))
				($if (value == 500))
					['not ok']
				($else)
					['not ok']
			($elseif (value == 4))
				($if (value > 3))
					($if (value > 2))
						['4']
				($elseif (value < 1))
					['not ok']
				($else)
					['not ok']
			($else)
				['not ok']
			];
		assert([[['4']]], rslt);
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
