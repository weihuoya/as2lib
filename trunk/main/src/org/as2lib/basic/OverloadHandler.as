/**
 * @author: Simon Wacker
 * @version: 1.0
 */
interface org.as2lib.basic.OverloadHandler {
	public function matches(someArguments:Array):Boolean;
	public function execute(anObject:Object, someArguments:Array):Void;
}