/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.aop.Weaver;
import org.as2lib.env.overload.Overload;
import org.as2lib.aop.Aspect;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.MethodJoinPoint;
import org.as2lib.aop.joinpoint.GetPropertyJoinPoint;
import org.as2lib.aop.joinpoint.SetPropertyJoinPoint;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.weaver.SimpleWeaver extends BasicClass implements Weaver {
	
	/** Stores all added aspects. */
	private var z:Array;
	
	/** Stores the added affected types. */
	private var y:Array;
	
	/** 
	 * Constructs a new SimpleWeaver instance.
	 */
	public function SimpleWeaver(Void) {
		z = new Array();
		y = new Array();
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#weave():Void
	 */
	public function weave():Void {
		var o:Overload = new Overload(this);
		o.addHandler([], weaveByVoid);
		o.addHandler([Function], weaveByClass);
		o.addHandler([Function, Aspect], weaveByClassAndAspect);
		o.addHandler([Object], weaveByObject);
		o.addHandler([Object, Aspect], weaveByObjectAndAspect);
		o.forward(arguments);
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#weaveByVoid(Void):Void
	 */
	public function weaveByVoid(Void):Void {
		var i:Number = z.length;
		while (--i-(-1)) {
			var a:Array = y[i];
			if (!a) {
				weaveByPackage(ReflectConfig.getRootPackage());
			} else {
				var k:Number = a.length;
				while (--k-(-1)) weaveByClassAndAspect(a[k], z[i]);
			}
		}
	}
	
	/**
	 * Iterates throught all sub-packages and weaves the added aspects
	 * in.
	 */
	private function weaveByPackage(a:PackageInfo):Void {
		var b:Array = a.getMemberClasses();
		var i:Number = b.length;
		while (--i-(-1)) weaveByClassInfo(b[i]);
		var c:Array = a.getMemberPackages();
		var k:Number = c.length;
		while (--k-(-1)) weaveByPackage(c[i]);
	}
	
	/**
	 * Iterates through all added aspects and weaves them into the
	 * provided class represented by a ClassInfo.
	 *
	 * @param a the ClassInfo instance that represents the class to weave all added aspects in
	 */
	private function weaveByClassInfo(a:ClassInfo):Void {
		var i:Number = z.length;
		while (--i-(-1)) weaveByClassInfoAndAspect(a, z[i]);
	}
	
	/**
	 * Weaves the passed Aspect into the class represented by the
	 * passed ClassInfo.
	 *
	 * @param a the ClassInfo instance that represents the class to weave the aspect in
	 * @param b the Aspect to be woven into the class
	 */
	private function weaveByClassInfoAndAspect(a:ClassInfo, b:Aspect):Void {
		var c:Array = a.getMethods();
		var d:Array = b.getAdvices();
		var i:Number = c.length;
		while (--i-(-1)) weaveByJoinPointAndAdvices(new MethodJoinPoint(c[i], a.getType().prototype), d);
		var e:Array = a.getProperties();
		var k:Number = e.length;
		while (--k-(-1)) {
			var f:PropertyInfo = e[i];
			var g:Object = a.getType().prototype;
			weaveByJoinPointAndAdvices(new GetPropertyJoinPoint(f, g), d);
			weaveByJoinPointAndAdvices(new SetPropertyJoinPoint(f, g), d);
		}
	}
	
	/**
	 * Iterates through the passed advice array weaving into the 
	 * join point.
	 *
	 * @param a the JoinPoint that shall be woven into
	 * @param b the Array of advices
	 */
	private function weaveByJoinPointAndAdvices(a:JoinPoint, b:Array):Void {
		var i:Number = b.length;
		while (--i-(-1)) {
			var c:Advice = b[i];
			if (c.captures(a)) weaveByJoinPointAndAdvice(a.clone(), c);
		}
	}
	
	/** 
	 * Weaves the advice into the join point.
	 *
	 * @param a the join point to weave into
	 * @param b the advice to be woven in
	 */
	private function weaveByJoinPointAndAdvice(a:JoinPoint, b:Advice) {
		var c:Function = b.getProxy(a);
		var d:TypeMemberInfo = a.getInfo();
		if (d.isStatic()) {
			d.getDeclaringType().getType()[d.getName()] = c;
		} else {
			d.getDeclaringType().getType().prototype[d.getName()] = c;
		}
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#weaveByClass(Function):Void
	 */
	public function weaveByClass(a:Function):Void {
		var i:Number = z.length;
		while (--i-(-1)) weaveByClassAndAspect(a, z[i]);
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#weaveByClass(Function, Aspect):Void
	 */
	public function weaveByClassAndAspect(a:Function, b:Aspect):Void {
		weaveByClassInfoAndAspect(ClassInfo.forClass(a), b);
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#weaveByClass(Object):Void
	 */
	public function weaveByObject(a:Object):Void {
		var i:Number = z.length;
		while (--i-(-1)) weaveByObjectAndAspect(a, z[i]);
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#weaveByClass(Object, Aspect):Void
	 */
	public function weaveByObjectAndAspect(a:Object, b:Aspect):Void {
		var c:ClassInfo = ClassInfo.forInstance(a);
		var d:Array = c.getMethods();
		var h:Array = b.getAdvices();
		var i:Number = d.length;
		while (--i-(-1)) weaveByJoinPointAndAdvicesAndObject(new MethodJoinPoint(d[i], c.getType().prototype), h, a);
		var e:Array = c.getProperties();
		var k:Number = e.length;
		while (--k-(-1)) {
			var f:PropertyInfo = e[i];
			var g:Object = c.getType().prototype;
			weaveByJoinPointAndAdvicesAndObject(new GetPropertyJoinPoint(f, g), h, a);
			weaveByJoinPointAndAdvicesAndObject(new SetPropertyJoinPoint(f, g), h, a);
		}
	}
	
	/**
	 * Weaves the passed advices at the given join point directly into
	 * the specific object.
	 *
	 * @param a the join point that is affected
	 * @param b the array of advices to be woven in
	 * @param c the object to weave into
	 */
	private function weaveByJoinPointAndAdvicesAndObject(a:JoinPoint, b:Array, c:Object):Void {
		var i:Number = b.length;
		while (--i-(-1)) {
			var d:Advice = b[i];
			if (d.captures(a)) c[a.getInfo().getName()] = d.getProxy(a);
		}
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#addAspect():Void
	 */
	public function addAspect():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Aspect], addAspectByAspect);
		o.addHandler([Aspect, Array], addAspectByAspectAndAffectedTypes);
		o.forward(arguments);
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#addAspectByAspect(Aspect):Void
	 */
	public function addAspectByAspect(a:Aspect):Void {
		addAspectByAspectAndAffectedTypes(a, null);
	}
	
	/**
	 * @see org.as2lib.aop.Weaver#addAspectByAspectAndAffectedTypes(Aspect, Array):Void
	 */
	public function addAspectByAspectAndAffectedTypes(a:Aspect, b:Array):Void {
		z.unshift(eval("a"));
		y.unshift(b);
	}
	
}