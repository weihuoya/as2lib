import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.AbstractPointcut extends BasicClass {
	private var joinPointDescription:String;
	
	private function AbstractPointcut(Void) {
	}
	
	private function setJoinPointDescription(description:String):Void {
		joinPointDescription = description;
	}
	
	private function getJoinPointDescription(Void):String {
		return joinPointDescription;
	}
}