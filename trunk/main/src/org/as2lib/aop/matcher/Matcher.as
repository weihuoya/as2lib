import org.as2lib.core.BasicClass;
import org.as2lib.util.StringUtil;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.matcher.Matcher extends BasicClass {
	private function Matcher(Void) {
	}
	
	public static function match(joinPoint:String, pattern:String):Boolean {
		if (pattern.indexOf("*") == -1
				&& pattern.indexOf("..") == -1) {
			return (joinPoint == pattern);
		}
		return wildcardMatch(joinPoint, pattern);
	}
	
	private static function wildcardMatch(jp:String, p:String):Boolean {
		var a:Array = jp.split(".");
		var b:Array = p.split(".");
		var c:Number = p.indexOf("..");
		var d:Number = a.length;
		var e:Number = b.length;
		if (c < 0 && d != e) return false;
		for (var i:Number = 0; i < d; i++) {
			var f:String = b[i];
			if (f == "") {
				f = b[i+1];
				var g:Boolean = false;
				for (var k:Number = i; k < e; k++) {
					if (matchString(a[k], f)) {
						if (k == i) b.shift();
						g = true;
						i = k;
						break;
					}
					if (k > i) b.unshift("");
				}
				if (!g) return false;
			} else {
				if (!matchString(a[i], f)) return false;
			}
		}
		if (a.length != b.length) return false;
		return true;
	}
	
	private static function matchString(s:String, p:String):Boolean {
		if (p == "*") return true;
		if (p.indexOf("*") > -1) {
			var a:Array = p.split("*");
			var b:Number = a.length;
			var z:Number = -1;
			for (var i:Number = 0; i < b; i++) {
				var c:String = a[i];
				if (c == "") continue;
				var d:Number = s.indexOf(c);
				if (d < 0) return false;
				if (d < z) return false;
				z = d;
			}
			return true;
		} else {
			return (s == p);
		}
	}
}