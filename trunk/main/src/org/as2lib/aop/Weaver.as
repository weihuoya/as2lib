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

import org.as2lib.core.BasicInterface;
import org.as2lib.aop.Aspect;

/**
 * A Weaver is responsible for weaving the aspect-oriented code
 * into the affected classes.
 * Refer to http://www.simonwacker.com/blog/archives/000040.php for
 * a short explanation of what a weaver is all about.
 *
 * @author Simon Wacker
 */
interface org.as2lib.aop.Weaver extends BasicInterface {
	
	/**
	 * @overload #weaveByVoid
	 * @overload #weaveByClass
	 * @overload #weaveByClassAndAspect
	 * @overload #weaveByObject
	 * @overload #weaveByObjectAndAspect
	 */
	public function weave():Void;
	
	/**
	 * Weaves the contents of all added aspects into the appropriate
	 * affected types.
	 */
	public function weaveByVoid(Void):Void;
	
	/**
	 * Weaves advices that capture any type member of the given class.
	 *
	 * @param clazz the class to weave in
	 */
	public function weaveByClass(clazz:Function):Void;
	
	/**
	 * Weaves the given aspect into the class.
	 *
	 * @param clazz the class to weave logic in
	 * @param aspect the aspect to obtain the advices to weave in from
	 */
	public function weaveByClassAndAspect(clazz:Function, aspect:Aspect):Void;
	
	/**
	 * Weaves the contents of all added aspects into the given object.
	 *
	 * @param object the object to weave logic in
	 */
	public function weaveByObject(object:Object):Void;
	
	/**
	 * Weaves the given aspect into the object.
	 *
	 * @param object the affected object to weave logic in
	 * @param aspect the aspect to obtain advices to weave in from
	 */
	public function weaveByObjectAndAspect(object:Object, aspect:Aspect):Void;
	
	/**
	 * @overload #addAspectByAspect
	 * @overload #addAspectByAspectAndAffectedTypes
	 */
	public function addAspect():Void;
	
	/**
	 * Adds an aspect to the list. The weaver will try to weave this aspect
	 * into any class.
	 *
	 * @param aspect the aspect to be added
	 */
	public function addAspectByAspect(aspect:Aspect):Void;
	
	/**
	 * Adds an aspect to the list. The weaver will only try to weave this
	 * aspect into any of the given affected types. This improves the overall
	 * performance.
	 *
	 * @param aspect the aspect to be added
	 * @param affectedTypes the types that shall be considered during the weaving process
	 */
	public function addAspectByAspectAndAffectedTypes(aspect:Aspect, affectedTypes:Array):Void;
	
}