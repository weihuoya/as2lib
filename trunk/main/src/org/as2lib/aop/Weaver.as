import org.as2lib.core.BasicInterface;
import org.as2lib.aop.Aspect;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.Weaver extends BasicInterface {
	public function weave():Void;
	public function weaveByVoid(Void):Void;
	public function weaveByClass(clazz:Function):Void;
	public function weaveByClassAndAspect(clazz:Function, aspect:Aspect):Void;
	public function weaveByObject(object:Object):Void;
	public function weaveByObjectAndAspect(object:Object, aspect:Aspect):Void;
	
	public function addAspect():Void;
	public function addAspectByAspect(aspect:Aspect):Void;
	public function addAspectByAspectAndAffectedTypes(aspect:Aspect, affectedTypes:Array):Void;
}