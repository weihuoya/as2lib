import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.SimpleStack;
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Aspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.MethodJoinPoint;
import org.as2lib.aop.joinpoint.GetPropertyJoinPoint;
import org.as2lib.aop.joinpoint.SetPropertyJoinPoint;
import org.as2lib.aop.proxy.MethodProxyFactory;
import org.as2lib.aop.aspect.AspectConfig;
import org.as2lib.aop.proxy.ProxyConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.AbstractAspect extends BasicClass {
	private var adviceStack:Stack;
	private var affectedTypeStack:Stack;
	
	private function AbstractAspect(Void) {
		adviceStack = new SimpleStack();
		affectedTypeStack = new SimpleStack();
	}
	
	public function addAffectedTypes(types:String):Void {
		var iterator:Iterator = AspectConfig.getTypeFactory().getTypes(types).iterator();
		while (iterator.hasNext()) {
			affectedTypeStack.push(TypeInfo(iterator.next()));
		}
	}
	
	private function addAdvice(advice:Advice):Void {
		adviceStack.push(advice);
	}
	
	public function weave(Void):Void {
		var iterator:Iterator = affectedTypeStack.iterator();
		while (iterator.hasNext()) {
			iterateType(TypeInfo(iterator.next()));
		}
	}
	
	private function iterateType(type:TypeInfo):Void {
		if (ObjectUtil.isInstanceOf(type, ClassInfo)) {
			iterateClass(ClassInfo(type));
			return;
		}
	}
	
	private function iterateClass(clazz:ClassInfo):Void {
		var methodIterator:Iterator = clazz.getMethods().iterator();
		while (methodIterator.hasNext()) {
			var method:MethodInfo = MethodInfo(methodIterator.next());
			var joinPoint:JoinPoint = new MethodJoinPoint(method, clazz.getType().prototype);
			iterateAdvices(joinPoint);
		}
		var propertyIterator:Iterator = clazz.getProperties().iterator();
		while (propertyIterator.hasNext()) {
			var property:PropertyInfo = PropertyInfo(propertyIterator.next());
			var getterJoinPoint:JoinPoint = new GetPropertyJoinPoint(property, clazz.getType().prototype);
			var setterJoinPoint:JoinPoint = new SetPropertyJoinPoint(property, clazz.getType().prototype);
			iterateAdvices(getterJoinPoint);
			iterateAdvices(setterJoinPoint);
		}
	}
	
	private function iterateAdvices(joinPoint:JoinPoint):Void {
		var iterator:Iterator = adviceStack.iterator();
		while (iterator.hasNext()) {
			var advice:Advice = Advice(iterator.next());
			if (advice.captures(joinPoint)) {
				weaveJoinPoint(advice, joinPoint.clone());
			}
		}
	}
	
	private function weaveJoinPoint(advice:Advice, joinPoint:JoinPoint):Void {
		var proxy:Function = ProxyConfig.getMethodProxyFactory().getMethodProxy(joinPoint, advice);
		if (joinPoint.getInfo().isStatic()) {
			var target:Function = joinPoint.getInfo().getDeclaringType().getType();
			//ObjectUtil.setAccessPermission(target, ObjectUtil.ACCESS_ALL_ALLOWED);
			target[joinPoint.getInfo().getName()] = proxy;
			return;
		}
		var target:Object = joinPoint.getInfo().getDeclaringType().getType().prototype;
		//ObjectUtil.setAccessPermission(target, ObjectUtil.ACCESS_ALL_ALLOWED);
		target[joinPoint.getInfo().getName()] = proxy;
	}
}