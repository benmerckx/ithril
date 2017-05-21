# ithril

[![Build Status](https://travis-ci.org/benmerckx/ithril.svg?branch=master)](https://travis-ci.org/benmerckx/ithril)

# Mithril 1.1.1 for Haxe.

Ithril uses Haxe macros to transpile Jade/Pug like templates into Mithril hyperscript.

## Template Syntax

Mithril views are declared in a class that extends `ithril.Component` or implements `ithril.View`.  The declaration must be inside `[`brackets`]` marked with a `@m` meta.

```haxe
import ithril.*;

class MyComponent extends Component {
    public override function view (vnode:Vnode) @m[
    	(div.intro)
    		(ul)
    			(li > 'Some')
    			(li > 'List items')
    		(ul.another-list)
    			(vnode.attrs.list => item)
    				(li > item)
    		(form)
    			(input[type="text"] (value = "Text value", onfocus = focus))
    			(input[type="checkbox"][required]) ['Check this']
    ];
}

class Views implements View {
    public function view1(vnode:Vnode) @m[
        (div > 'view one')
            (MyComponent(list=['item one', 'item two', 'item three']))
    ]

    public function view2(vnode:Vnode) @m[
        (div > 'view two')
            (MyComponent(list=['apples', 'oranges', 'bananas']))
    ]}
}
```

#### Elements

Any html element can be expressed in parentheses:
```haxe
(img)
```

CSS classes can be set using the `.` operator:
```haxe
(img.my-class-name.my-other-class-name)
```

An element id can be set with the `+` operator (as # wouldn't be valid haxe syntax):
```haxe
(img+my-id)
```

Attributes can be used inside the selector:
```haxe
(img[src="img.jpg"])
```

Attributes can also be expressed separately:
```haxe
(img (src="img.jpg", alt=""))
(img ({src: "img.jpg", alt: ""}))
(img (aFunctionCallReturningAttributes()))
```

#### Children

A shortcut for defining one child:
```haxe
(h1 > 'My title')
```

More than one child can simply be nested by using indentation:
```haxe
    (nav)
    	(ul.links)
    		(li)
    			(a[href="http://haxe.org"] > 'Haxe')
    		(li)
    			(a[href="http://github.com"] > 'Github')
```

#### Inline expressions

Any expression can be used inside brackets:
```haxe
(h1)
	['A string for example']
(button)
	[this.buttonLabel]
(div)
    [{
        var blockExpression = "is Ok";
        return blockExpression;
    }]
(div)
    [{
        return true ? @m[
            (div > 'this works too')
        ] : @m [ ]
    }]
```

#### Conditionals

`$if`, `$elseif`, and `$else` can be used inside templates:

```haxe
($if (headerSize == 1))
	(h1 > 'Big')
($elseif (headerSize == 2))
	(h2 > 'Not that big')
($else)
	(p > 'Paragraph')
```

#### For loop

```haxe
(link in links)
	(a (href=link.url, target='_blank') > link.title)

// or:

($for (link in links))
	(a (href=link.url, target='_blank') > link.title)

```

#### While loop

```haxe
($while (expr))
	(div > 'text')
```

#### Map

The following syntax can be used for any object (in this case `links`) with a map method:

```haxe
(links => link)
	(a (href=link.url, target='_blank') > link.title)
```

#### Map with null check

Using the `>>` or `<<` operator adds a null check prior to map execution.

```haxe
// using >>:

(links >> link)
	(a (href=link.url, target='_blank') > link.title)

// or using <<:

(link << links)
	(a (href=link.url, target='_blank') > link.title)

```

Translates to:

```haxe
if (links != null)
	[links.map(function(link) m('a', { href: link.url, target: '_blank' }, [ link.title ])];
else
	[];
```

#### Try/Catch

Try/Catch is limited to a single catch of the Dynamic type.

```haxe
($try)
	(div > functionThatThrows())
($catch (err))
	(div > err)
```

#### Trusted HTML

Embedding javascript or CSS assets requires marking content as trusted so it is not automatically escaped.  Use the `@trust` meta:
```haxe
(style > @trust css)
(script)
    [@trust javascript]
```

## Components

Custom components can be created by extending `ithril.Component`.  A component can then be used in a view like any other element:
```haxe
class Hello extends Component {
    public override function view (vnode:Vnode) @m[
    	(div.component > 'Hello ' + vnode.attrs.name)
    ];
}

class World implements View {
    public function helloView(vnode:Vnode) @m[
            (Hello(name='World'))
    ]
}
```

#### Children

Children of a Component can be accessed via `vnode.children`:
```haxe
class List extends Component {
	public function view(vnode:Vnode) [
		(ul)
			(vnode.children => child)
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

#### Lifecycle

Mithril creates, reuses, and destroys components as specified by it's diffing algorithm.  The lifecycle of a `Component` can be observed by overriding these methods:
```haxe
	public function oninit(vnode:Vnode) {}
	public function oncreate(vnode:Vnode) {}
	public function onupdate(vnode:Vnode) {}
	public function onbeforeremove(vnode:Vnode) {}
	public function onremove(vnode:Vnode) {}
	public function onbeforeupdate(vnode:Vnode) {}
```
You can also specify these methods as attributes of both regular elements and components:
```haxe
    (div(oncreate=function() trace('oncreate')))
    (MyComponent(oncreate=function() trace('oncreate')))
```

#### State

Mithril manages component state by cloning a component's fields post-constructor and storing them in `vnode.state`.  Because component instances can be cached and reused by Mithril, accessing state must be thru `vnode.state` unless the initial state is being set.

```haxe
class StatefulComponent extends Component {
    var someState = "my state"; // set initial state value here or in constructor
    var someMoreState:String;

    override public function new(vnode:Vnode) {
        someMoreState = "other state"; // can also set initial component state here
    }

    override public function view(vnode:Vnode) @m[
        (div > vnode.state.someState) // access it via vnode.state
            [vnode.state.someMoreState]
    ]
}
```

#### Rendering

Components can be rendered by passing a Component class to Mithril:
```haxe
M.mount(js.Browser.document.body, MyComponent);
```

Or may be rendered in nodejs as html:
```haxe
HTMLRenderer.render(Ithril.view(@m[ (div > 'view') ])).then(function(html) Sys.print(html))
```

Mithril routing is also supported:
```haxe
M.route(js.Browser.document.body, "/", routes);
```

## Usage

Any of your class methods can use ithril syntax if you either implement `ithril.View` or extend `ithril.Component`.  Additionally you can use the static function `ithril.Ithril.view` to parse an ithril view.

```haxe
import ithril.*;
import ithril.M.*;

class Web extends Component {
	override public function view(vnode) @m[
#if nodejs
		(!doctype)
		(meta[charset="utf-8"])
		(link[href="layout.css"][rel="stylesheet"])
		(body)
#end
			(div.intro)
				(h1 > 'Ithril example')
				(p > 'Hello world')
#if nodejs
		(script[src="https://cdnjs.cloudflare.com/ajax/libs/mithril/1.1.1/mithril.min.js"])
		(script[src="main.js"])
#end
	];

}

class Main {
	public static function main() {
		// On the server
		#if nodejs 
		HTMLRenderer.render(Web).then(function(html) Sys.print(html));
		#else
		// On the client
		M.mount(js.Browser.document.body, Web);
		#end
	}
}
```

You can find this usage example in `examples/simple`.

## Output

`@m[ (div(attrs)) ]` is transpiled to Mithril hyperscript `m('div', attrs)`.  On the browser end, it's passed directly to Mithril.  In server instances `ithril.HTMLRenderer` can be used to render HTML.

## Sample Website

An example website can be found at `examples/website`.  You will need `node`, `npm`, `sass`, and either `closure` or `uglifyjs` installed in order to build and run it.

Initial build: (this will run `npm install`)
```bash
cd examples/website
haxe build.hxml
```

Start webserver: (listens on localhost:4200, and restarts when webserver.js changes)
```bash
npm run start
```

Auto-build: (rebuilds on file changes)
```bash
npm run autobuild
```
