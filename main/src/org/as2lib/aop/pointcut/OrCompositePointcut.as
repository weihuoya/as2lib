﻿import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.SimpleStack;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.aop.pointcut.CompositePointcut;
import org.as2lib.aop.pointcut.AbstractCompositePointcut;
import org.as2lib.aop.pointcut.PointcutConfig;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.OrCompositePointcut extends AbstractCompositePointcut implements CompositePointcut {
	public function OrCompositePointcut(pointcutString:String) {
		var pointcuts:Array = pointcutString.split(" || ");
		for (var i:Number = 0; i < pointcuts.length; i++) {
			addPointcut(PointcutConfig.getPointcutFactory().getPointcut(pointcuts[i]));
		}
	}
	
	public function captures(joinPoint:JoinPoint):Boolean {
		var iterator:Iterator = pointcutStack.iterator();
		while (iterator.hasNext()) {
			var pointcut:Pointcut = Pointcut(iterator.next());
			if (pointcut.captures(joinPoint)) {
				return true;
			}
		}
		return false;
	}
}