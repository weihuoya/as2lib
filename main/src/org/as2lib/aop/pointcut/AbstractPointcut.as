import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.AbstractPointcut extends BasicClass {
	private var joinPointPattern:String;
	
	private function AbstractPointcut(Void) {
	}
	
	private function setJoinPointPattern(pattern:String):Void {
		joinPointPattern = pattern;
	}
	
	private function getJoinPointPattern(Void):String {
		return joinPointPattern;
	}
}