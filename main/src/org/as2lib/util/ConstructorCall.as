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

import org.as2lib.util.ClassUtil;
import org.as2lib.app.exec.Call;

/**
 * {@code ConstructorCall} enables you to create instances of a class without having
 * to know the class itself.
 * 
 * @author Martin Heidegger
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.util.ConstructorCall extends Call {
	
	/** The class to instantiate. */
	private var clazz:Function;
	
	/**
	 * Constructs a new {@code ConstructorCall} instance.
	 *
	 * @param clazz the class to instantiate
	 */
	public function ConstructorCall(clazz:Function) {
		super (this, clazz);
		this.clazz = clazz;
	}
	
	/**
	 * Creates a new instance of the class specified on construction passing the given
	 * {@code args} as parameters.
	 * 
	 * @param args the arguments to pass as parameters to the class's constructor
	 * @return a new instance of the class specified on construction
	 */
	public function execute() {
		var instance = ClassUtil.createCleanInstance(clazz);
		return clazz.apply(instance, arguments);
	}
	
}