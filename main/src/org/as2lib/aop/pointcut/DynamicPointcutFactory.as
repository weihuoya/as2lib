import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.pointcut.OrCompositePointcut;
import org.as2lib.aop.pointcut.AndCompositePointcut;
import org.as2lib.aop.pointcut.KindedPointcut;
//import org.as2lib.aop.pointcut.WithinPointcut;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.pointcut.PointcutRule;
import org.as2lib.aop.joinpoint.AbstractJoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.DynamicPointcutFactory extends BasicClass implements PointcutFactory {
	private var factoryMap:Map;
	
	public function DynamicPointcutFactory(Void) {
		factoryMap = new HashMap();
		bindOrCompositePointcut();
		bindAndCompositePointcut();
		bindMethodPointcut();
		bindSetPropertyPointcut();
		bindGetPropertyPointcut();
		//bindWithinPointcut();
	}
	
	private function bindOrCompositePointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(description:String):Boolean {
			return (description.indexOf(" || ") != -1);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(description:String):Pointcut {
			return (new OrCompositePointcut(description));
		}
		bindFactory(rule, factory);
	}
	
	private function bindAndCompositePointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(description:String):Boolean {
			return (description.indexOf(" && ") != -1);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(description:String):Pointcut {
			return (new AndCompositePointcut(description));
		}
		bindFactory(rule, factory);
	}
	
	private function bindMethodPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(description:String):Boolean {
			return (description.indexOf("execution") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(description:String):Pointcut {
			description = description.substring(10, description.length - 3);
			return (new KindedPointcut(description, AbstractJoinPoint.TYPE_METHOD));
		}
		bindFactory(rule, factory);
	}
	
	private function bindSetPropertyPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(description:String):Boolean {
			return (description.indexOf("set") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(description:String):Pointcut {
			description = description.substring(4, description.length - 1);
			return (new KindedPointcut(description, AbstractJoinPoint.TYPE_SET_PROPERTY));
		}
		bindFactory(rule, factory);
	}
	
	private function bindGetPropertyPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(description:String):Boolean {
			return (description.indexOf("get") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(description:String):Pointcut {
			description = description.substring(4, description.length - 1);
			return (new KindedPointcut(description, AbstractJoinPoint.TYPE_GET_PROPERTY));
		}
		bindFactory(rule, factory);
	}
	
	/*private function bindWithinPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(description:String):Boolean {
			return (description.indexOf("within") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(description:String):Pointcut {
			description = description.substring(7, description.length - 1);
			return (new WithinPointcut(description));
		}
		bindFactory(rule, factory);
	}*/
	
	public function getPointcut(description:String):Pointcut {
		var iterator:Iterator = new ArrayIterator(factoryMap.getKeys());
		while (iterator.hasNext()) {
			var rule:PointcutRule = iterator.next();
			if (rule.execute(description)) {
				return factoryMap.get(rule).getPointcut(description);
			}
		}
	}
	
	public function bindFactory(rule:PointcutRule, factory:PointcutFactory):Void {
		factoryMap.put(rule, factory);
	}
}