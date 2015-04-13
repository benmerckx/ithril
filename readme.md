#Ithril

Simple template syntax for mithril views.
It's aware of indentation so you don't have to close tags. 
You can use the same kind of selectors as in mithril, except for ids (since using # would not be valid haxe syntax, these are replace with +):
Normal expressions can be used in attribute values and inline by using brackets. Inline for and while loops only need one set of brackets.

## Example

You need to implement `ithril.View` for the macros to do their work.

```haxe
function () {
	return (view)
		(head)
			(meta[charset="utf-8"])
		(body)
			(div.class-name)
				['Any expression can be used here']
			(div+id)
				(ul)
					(li, 'Some')
					(li, 'List items')
				(ul.another-list)
					[for (item in list) (view)(li, item.title)]
				(form)
					(input[type="text"], {value: "Text value"})
					(input[type="checkbox"], {checked: true})
			(footer)
				['More information will be following']
	;
}
```