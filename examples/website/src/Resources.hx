import util.From;
class Resources {
#if compress
	public static var javascript = [
		#if uglifyjs
		From.command('uglifyjs', [
				'--compress', 
				'--mangle', 
				'--', 
				'node_modules/mithril/mithril.min.js', 
				'obj/browser.js',
		]),
		#else
		From.file('node_modules/mithril/mithril.min.js'),
		From.command('closure-compiler', [
				'-O', 'SIMPLE', 
				'obj/browser.js',
		]),
		#end
	];

	public static var css = [
		From.command('sass', [ 
				'include/css/style.scss', 
				'--style', 'compressed',
		]),
	];
#else
	public static var javascript = [
		From.file('node_modules/mithril/mithril.js'),
		From.file('obj/browser.js'),
	];
	public static var css = [
		From.command('sass', [ 
				'include/css/style.scss', 
				'--style', 'compact' 
		]),
	];
#end
}
