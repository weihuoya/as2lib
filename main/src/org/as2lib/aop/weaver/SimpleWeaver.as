import org.as2lib.core.BasicClass;
import org.as2lib.aop.Weaver;
import org.as2lib.env.overload.Overload;
import org.as2lib.aop.Aspect;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.MethodJoinPoint;
import org.as2lib.aop.joinpoint.GetPropertyJoinPoint;
import org.as2lib.aop.joinpoint.SetPropertyJoinPoint;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.weaver.SimpleWeaver extends BasicClass implements Weaver {
	private var z:Array;
	private var y:Array;
	
	public function SimpleWeaver(Void) {
		z = new Array();
		y = new Array();
	}
	
	public function weave():Void {
		var o:Overload = new Overload(this);
		o.addHandler([], weaveByVoid);
		o.addHandler([Function], weaveByClass);
		o.addHandler([Function, Aspect], weaveByClassAndAspect);
		o.addHandler([Object], weaveByObject);
		o.addHandler([Object, Aspect], weaveByObjectAndAspect);
		o.forward(arguments);
	}
	
	public function weaveByVoid(Void):Void {
		var i:Number = z.length;
		while (--i-(-1)) {
			var a:Array = y[i];
			if (!a) {
				weaveByPackage(ReflectUtil.getRootInfo());
			} else {
				var k:Number = a.length;
				while (--k-(-1)) weaveByClassAndAspect(a[k], z[i]);
			}
		}
	}
	
	private function weaveByPackage(a:PackageInfo):Void {
		var b:Array = a.getChildClasses().getValues();
		var i:Number = b.length;
		while (--i-(-1)) weaveByClassInfo(b[i]);
		var c:Array = a.getChildPackages().getValues();
		var k:Number = c.length;
		while (--k-(-1)) weaveByPackage(c[i]);
	}
	
	private function weaveByClassInfo(a:ClassInfo):Void {
		var i:Number = z.length;
		while (--i-(-1)) weaveByClassInfoAndAspect(a, z[i]);
	}
	
	private function weaveByClassInfoAndAspect(a:ClassInfo, b:Aspect):Void {
		var c:Array = a.getMethods().getValues();
		var d:Array = b.getAdvices();
		var i:Number = c.length;
		while (--i-(-1)) weaveByJoinPointAndAdvices(new MethodJoinPoint(c[i], a.getType().prototype), d);
		var e:Array = a.getProperties().getValues();
		var k:Number = e.length;
		while (--k-(-1)) {
			var f:PropertyInfo = e[i];
			var g:Object = a.getType().prototype;
			weaveByJoinPointAndAdvices(new GetPropertyJoinPoint(f, g), d);
			weaveByJoinPointAndAdvices(new SetPropertyJoinPoint(f, g), d);
		}
	}
	
	private function weaveByJoinPointAndAdvices(a:JoinPoint, b:Array):Void {
		var i:Number = b.length;
		while (--i-(-1)) {
			var c:Advice = b[i];
			if (c.captures(a)) weaveByJoinPointAndAdvice(a.clone(), c);
		}
	}
	
	private function weaveByJoinPointAndAdvice(a:JoinPoint, b:Advice) {
		var c:Function = b.getProxy(a);
		var d:TypeMemberInfo = a.getInfo();
		if (d.isStatic()) {
			d.getDeclaringType().getType()[d.getName()] = c;
		} else {
			d.getDeclaringType().getType().prototype[d.getName()] = c;
		}
	}
	
	public function weaveByClass(a:Function):Void {
		var i:Number = z.length;
		while (--i-(-1)) weaveByClassAndAspect(a, z[i]);
	}
	
	public function weaveByClassAndAspect(a:Function, b:Aspect):Void {
		weaveByClassInfoAndAspect(ReflectUtil.getClassInfo(a), b);
	}
	
	public function weaveByObject(a:Object):Void {
		var i:Number = z.length;
		while (--i-(-1)) weaveByObjectAndAspect(a, z[i]);
	}
	
	public function weaveByObjectAndAspect(a:Object, b:Aspect):Void {
		var c:ClassInfo = ReflectUtil.getClassInfo(a);
		var d:Array = c.getMethods().getValues();
		var h:Array = b.getAdvices();
		var i:Number = d.length;
		while (--i-(-1)) weaveByJoinPointAndAdvicesAndObject(new MethodJoinPoint(d[i], c.getType().prototype), h, a);
		var e:Array = c.getProperties().getValues();
		var k:Number = e.length;
		while (--k-(-1)) {
			var f:PropertyInfo = e[i];
			var g:Object = c.getType().prototype;
			weaveByJoinPointAndAdvicesAndObject(new GetPropertyJoinPoint(f, g), h, a);
			weaveByJoinPointAndAdvicesAndObject(new SetPropertyJoinPoint(f, g), h, a);
		}
	}
	
	private function weaveByJoinPointAndAdvicesAndObject(a:JoinPoint, b:Array, c:Object):Void {
		var i:Number = b.length;
		while (--i-(-1)) {
			var d:Advice = b[i];
			if (d.captures(a)) c[a.getInfo().getName()] = d.getProxy(a);
		}
	}
	
	public function addAspect():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Aspect], addAspectByAspect);
		o.addHandler([Aspect, Array], addAspectByAspectAndAffectedTypes);
		o.forward(arguments);
	}
	
	public function addAspectByAspect(a:Aspect):Void {
		addAspectByAspectAndAffectedTypes(a, null);
	}
	
	public function addAspectByAspectAndAffectedTypes(a:Aspect, b:Array):Void {
		z.push(a);
		y.push(b);
	}
}