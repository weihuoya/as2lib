import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.overload.Overload;
import org.as2lib.aop.joinpoint.JoinPointDescription;
import org.as2lib.aop.joinpoint.JoinPointConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.AbstractPointcut extends BasicClass {
	private var joinPointDescription:JoinPointDescription;
	
	private function AbstractPointcut(Void) {
	}
	
	private function setJoinPointDescription(description):Void {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], setJoinPointDescriptionByString);
		overload.addHandler([JoinPointDescription], setJoinPointDescriptionByDescirption);
		overload.forward(arguments);
	}
	
	private function setJoinPointDescriptionByString(description:String):Void {
		joinPointDescription = new JoinPointDescription(description);
	}
	
	private function setJoinPointDescriptionByDescirption(description:JoinPointDescription):Void {
		joinPointDescription = description;
	}
	
	private function getJoinPointDescription(Void):JoinPointDescription {
		return joinPointDescription;
	}
}