import org.as2lib.core.BasicClass;
import org.as2lib.util.StringUtil;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.JoinPointDescription;
import com.pf.core.string.RegExp;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.matcher.Matcher extends BasicClass {
	private function Matcher(Void) {
	}
	
	public static function matches(joinPoint:JoinPoint, description:JoinPointDescription):Boolean {
		// wenn '+' dann alle Superklassen durchgehen und bei ihnen auf match prüfen
		// mh....Performance?
		var expression = joinPoint.getInfo().getDeclaringType().getFullName() + "." + joinPoint.getInfo().getName();
		if (description.getDescription().indexOf("+") == -1
				&& description.getDescription().indexOf("..") == -1) {
			return (expression == description.getDescription());
		}
		var re:RegExp = new RegExp(convertDescription(description.getDescription()));
		return expression.match(re);
	}
	
	private static function convertDescription(description:String):String {
		var result:String = "^" + description + "$";
		result = StringUtil.replace(description, "*", "[a-zA-Z0-9]*");
		return StringUtil.replace(result, "..", "[a-zA-Z0-9\w\\.]*");
	}
}