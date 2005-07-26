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
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.MethodJoinPoint;
import org.as2lib.aop.joinpoint.GetPropertyJoinPoint;
import org.as2lib.aop.joinpoint.SetPropertyJoinPoint;
import org.as2lib.aop.Advice;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.Map;
import org.as2lib.env.reflect.MethodInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.weaver.SimpleWeaver extends BasicClass implements Weaver {
	
	private var advices:Map;
	
	public function SimpleWeaver(Void) {
		advices = new HashMap();
	}
	
	public function weave(Void):Void {
		var affectedTypes:Array = advices.getKeys();
		for (var i:Number = 0; i < affectedTypes.length; i++) {
			var affectedType:Function = affectedTypes[i];
			var affectedAdvices:Array = advices.get(affectedType);
			if (affectedType) {
				weaveByTypeAndAdvices(ClassInfo.forClass(affectedType), affectedAdvices);
			} else {
				weaveByPackageAndAdvices(PackageInfo.getRootPackage(), affectedAdvices);
			}
		}
	}
	
	private function weaveByPackageAndAdvices(package:PackageInfo, advices:Array):Void {
		if (package) {
			if (advices) {
				var classes:Array = package.getMemberClasses(false);
				if (classes) {
					for (var i:Number = 0; i < classes.length; i++) {
						var clazz:ClassInfo = ClassInfo(classes[i]);
						if (clazz) {
							weaveByTypeAndAdvices(clazz, advices);
						}
					}
				}
			}
		}
	}
	
	private function weaveByTypeAndAdvices(type:ClassInfo, advices:Array):Void {
		var methods:Array = type.getMethods();
		if (methods) {
			for (var i:Number = 0; i < methods.length; i++) {
				var method:MethodInfo = MethodInfo(methods[i]);
				if (method) {
					weaveByJoinPointAndAdvices(new MethodJoinPoint(method, null), advices);
				}
			}
		}
		var properties:Array = type.getProperties();
		if (properties) {
			for (var i:Number = 0; i < properties.length; i++) {
				var property:PropertyInfo = PropertyInfo(properties[i]);
				if (property) {
					weaveByJoinPointAndAdvices(new GetPropertyJoinPoint(property, null), advices);
					weaveByJoinPointAndAdvices(new SetPropertyJoinPoint(property, null), advices);
				}
			}
		}
	}
	
	private function weaveByJoinPointAndAdvices(joinPoint:JoinPoint, advices:Array):Void {
		if (joinPoint) {
			if (advices) {
				for (var i:Number = 0; i < advices.length; i++) {
					var advice:Advice = Advice(advices[i]);
					if (advice) {
						if (advice.captures(joinPoint)) {
							weaveByJoinPointAndAdvice(joinPoint.snapshot(), advice);
						}
					}
				}
			}
		}
	}
	
	private function weaveByJoinPointAndAdvice(joinPoint:JoinPoint, advice:Advice) {
		var proxy:Function = advice.getProxy(joinPoint);
		var info:TypeMemberInfo = joinPoint.getInfo();
		if (info.isStatic()) {
			info.getDeclaringType().getType()[info.getName()] = proxy;
		} else {
			info.getDeclaringType().getType().prototype[info.getName()] = proxy;
		}
	}
	
	public function addAspect():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Aspect], addAspectForAllTypes);
		o.addHandler([Aspect, Array], addAspectForMultipleAffectedTypes);
		o.addHandler([Aspect, Function], addAspectForOneAffectedType);
		o.forward(arguments);
	}
	
	public function addAspectForAllTypes(aspect:Aspect):Void {
		if (aspect) {
			addAspectForOneAffectedType(aspect, null);
		}
	}
	
	public function addAspectForMultipleAffectedTypes(aspect:Aspect, affectedTypes:Array):Void {
		if (aspect) {
			if (affectedTypes) {
				for (var i:Number = 0; i < affectedTypes.length; i++) {
					var affectedType:Function = Function(affectedTypes[i]);
					if (affectedType) {
						addAspectForOneAffectedType(aspect, affectedType);
					}
				}
			} else {
				addAspectForOneAffectedType(aspect, null);
			}
		}
	}
	
	public function addAspectForOneAffectedType(aspect:Aspect, affectedType:Function):Void {
		if (aspect) {
			var advices:Array = aspect.getAdvices();
			if (advices) {
				for (var i:Number = 0; i < advices.length; i++) {
					var advice:Advice = Advice(advices[i]);
					if (advice) {
						addAdviceForOneAffectedType(advice, affectedType);
					}
				}
			}
		}
	}
	
	public function addAdvice():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Advice], addAdviceForAllTypes);
		o.addHandler([Advice, Array], addAdviceForMultipleAffectedTypes);
		o.addHandler([Advice, Function], addAdviceForOneAffectedType);
		o.forward(arguments);
	}
	
	public function addAdviceForAllTypes(advice:Advice):Void {
		if (advice) {
			addAdviceForOneAffectedType(advice, null);
		}
	}
	
	public function addAdviceForMultipleAffectedTypes(advice:Advice, affectedTypes:Array):Void {
		if (advice) {
			if (affectedTypes) {
				for (var i:Number = 0; i < affectedTypes.length; i++) {
					var affectedType:Function = Function(affectedTypes[i]);
					if (affectedType) {
						addAdviceForOneAffectedType(advice, affectedType);
					}
				}
			} else {
				addAdviceForOneAffectedType(advice, null);
			}
		}
	}
	
	public function addAdviceForOneAffectedType(advice:Advice, affectedType:Function):Void {
		if (advice) {
			if (!advices.containsKey(affectedType)) {
				advices.put(affectedType, new Array());
			}
			var affectedAdvices:Array = advices.get(affectedType);
			affectedAdvices.push(advice);
		}
	}
	
}