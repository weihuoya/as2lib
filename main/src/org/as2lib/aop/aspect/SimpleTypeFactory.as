import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.SimpleStack;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.aop.aspect.TypeFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.SimpleTypeFactory extends BasicClass implements TypeFactory {
	public function SimpleTypeFactory(Void) {
	}
	
	public function getTypes(types:String):Stack {
		var result:Stack = new SimpleStack();
		var typeArray:Array = types.split(" || ");
		for (var i:Number = 0; i < typeArray.length; i++) {
			// There should be an operation called ReflectUtil#getTypeInfo()
			result.push(ReflectUtil.getClassInfo(typeArray[i]));
		}
		return result;
	}
}