# ithril

[![Build Status](https://travis-ci.org/benmerckx/ithril.svg?branch=master)](https://travis-ci.org/benmerckx/ithril)

Templates for haxe. Compiles to HTML or [Mithril](https://github.com/ciscoheat/mithril-hx) views.

```haxe
function () [
	(div.intro)
		(ul)
			(li > 'Some')
			(li > 'List items')
		(ul.another-list)
			(list => item)
				(li > item.title)
		(form)
			(input[type="text"] (value = "Text value", onfocus = focus))
			(input[type="checkbox"][required]) ['Check this']
];
```

## Syntax

Ithril views must be declared inside brackets. If used in a method they will always return.

### Elements

Any html element can be expressed in parentheses:  
`(img)`

The class can be set as in a css selector:  
`(img.my-class-name)`

An id can be added to the selector with + (as # wouldn't be valid haxe syntax):  
`(img+my-id)`

Attributes can be used inside the selector:  
`(img[src="img.jpg"])`

Attributes can also be expressed separately:  
`(img (src="img.jpg", alt=""))`  
`(img ({src: "img.jpg", alt: ""}))`  
`(img (aFunctionCallReturningAttributes()))`

### Children

A shortcut for defining one child:  
`(h1 > 'My title')`

More than one child can simply be nested by using indentation:

```haxe
(nav)
	(ul.links)
		(li)
			(a[href="http://haxe.org"] > 'Haxe')
		(li)
			(a[href="http://github.com"] > 'Github')
```

### Inline expressions

Any expression can be used inside brackets:
```haxe
(h1)
	['A string for example']
(button)
	[this.buttonLabel]
```

### Conditionals

If/else can be used inside templates (`$ifelse` is on the todo list):
```haxe
($if (bigTitle))
	(h1 > 'Big')
($else)
	(h2 > 'Not that big')
```

### For loop

```haxe
($for (link in links))
	(a (href=link.url, target='_blank') > link.title)
```

### Map

Following syntax can be used for any object (in this case `links`) with a map method:
```haxe
(links => link)
	(a (href=link.url, target='_blank') > link.title)
```

## Components

Custom components can be created by extending `ithril.Component`.  
A component can then be used in your view like any other element:  
`(MyComponent (attr1=1, attr2=2))`

### State

A component's attributes are type checked, so the example above would have to be defined like this:  
`class MyComponent extends Component<{attr1: Int, attr2: Int}>`

If no attributes are needed, you don't have to define a type parameter:  
`class MyComponent extends Component`

You can also require an instance:  
`class Label extends Component<String>`  
Usage would be:  
`(Label ('My text'))`

State can be accessed inside the component:
```haxe
class MyComponent extends Component<{attr1: Int, attr2: Int}> {
	pubic function view() [
		(div.my-comp)
			(span.attr > 'Attribute 1'+state.attr1)
			(span.attr > 'Attribute 2'+state.attr2)
	];
}
```

### Children

Children of a Component can be used however you like (`children => child` is [map syntax](#map)):
```haxe
class List extends Component {
	public function view() [
		(ul)
			(children => child)
				(li > child)
	];
}
```

Which can be used like this:
```haxe
(List)
	(span > 'A')
	(span > 'B')
	(span > 'C')
```

And would output:
```html
<ul>
	<li><span>A</span></li>
	<li><span>B</span></li>
	<li><span>C</span></li>
</ul>
```

### Lifecycle

A component is cached while it's in view. You can perform an action the moment it's created or destroyed (no longer in view) by using `mount` and `unmount`. This can be useful to, for example, set/unset listeners. These methods are only called on the client side.

```haxe
class Container extends Component {
	override public function mount()
		js.Browser.window.addEventListener('resize', resize);

	override public function unmount()
		js.Browser.window.removeEventListener('resize', resize);

	function resize(e)
		trace('Resize event!');
}
```

### Rendering

Components can be rendered by passing an instance to mithril:  
`M.mount(js.Browser.document.body, component);`

Or may be rendered as html (string):  
`Sys.print(component.asHTML());`

## Usage

Any of your class methods can use ithril syntax if you either implement `ithril.Ithril` or extend `ithril.Component`.

```haxe
class Web extends ithril.Component {
	public function layout() [
		(!doctype)
		(meta[charset="utf-8"])
		(link[href="layout.css"][rel="stylesheet"])
		(body)
			[view()]
		(script[src="https://cdnjs.cloudflare.com/ajax/libs/mithril/0.2.0/mithril.min.js"])
		(script[src="main.js"])
	];

	public function view() [
		(div.intro)
			(h1 > 'Ithril example')
			(p > 'Hello world')
	];

	public static function main() {
		// On the server
		#if !js
		Sys.print(ithril.HTMLRenderer.render(new Web().layout()));
		#else
		// On the client
		mithril.M.mount(js.Browser.document.body, new Web());
		#end
	}
}
```

## Output

Everything gets compiled to simple objects, using [this notation](http://lhorie.github.io/mithril/optimizing-performance.html#compiling-templates) so the output can be used directly with Mithril. Use `ithril.HTMLRenderer.render` to render the output to a string.
