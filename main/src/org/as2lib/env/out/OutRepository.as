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
import org.as2lib.env.out.OutFactory;
import org.as2lib.env.out.Out;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.out.OutRepository extends BasicInterface {
	
	/**
	 * @overload #getOutByName()
	 * @overload #getOutByNameAndFactory()
	 */
	public function getOut():Out;
	
	/**
	 * Returns an instance of class Out depending on the name. That means either
	 * a completely new instance will be returned or one that has already been
	 * obtained via the same name. The name can be composed of the path as well
	 * as the identifier, e.g. org.as2lib.core.BasicClass.
	 *
	 * @param name the name of the Out instance to obtain
	 * @return an Out instance depending on the passed name
	 */
	public function getOutByName(name:String):Out;
	
	/**
	 * Does the same as the #getOut() operation but obtains the new Out instance
	 * if appropriate from the passed factory.
	 *
	 * @param name the name of the Out instance to obtain
	 * @return either a new Out instance returned by the factory or an already existing one
	 */
	public function getOutByNameAndFactory(name:String, factory:OutFactory):Out;
	
	/**
	 * Returns the root out instance of the whole hierachy. The root out instance
	 * ever exists and has no parent.
	 *
	 * @return the root out instance
	 */
	public function getRootOut(Void):Out;
	
}