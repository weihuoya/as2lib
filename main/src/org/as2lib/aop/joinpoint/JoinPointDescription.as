import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.JoinPointDescription extends BasicClass {
	private var description:String;
	
	public function JoinPointDescription(description:String) {
		this.description = description;
	}
										 
	public function getDescription(Void):String {
		return description;
	}
}