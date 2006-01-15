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

/**
 * {@code Configuration} is intended for general configuration at start-up, that
 * is the same for Flash, Flex and MTASC. The {@link Flash}, {@link Flex} and
 * {@link Mtasc} classes extend this class.
 * 
 * <p>Note that this class is not necessary, it is just needed if there is common
 * start-up code for your application in Flash, Flex and Mtasc to avoid code
 * duplication.
 * 
 * <p>Example:
 * <code>
 *   import com.domain.myapplication.MyApplication;
 *   
 *   class main.Configuration {
 *     private var application:MyApplication;
 *     
 *     public function init(Void);Void {
 *       application = new MyApplication();
 *       application.start();
 *     }
 *   }
 * </code>
 * 
 * <p>While the configuration done in the {@code Flash}, {@code Flex} and {@code Mtasc}
 * class may suffice for your application, this class does not, because it contains
 * no code. You must override this class in the {@code main} package of your application.
 * Because there obviously exist at least to {@code Configuration} class, this one
 * and the one of you application, you must keep careful attention to the order of
 * your classpaths. Your application classes must have a higher priority.
 * 
 * <p>The Macromedia Flash Compiler takes the topmost as most important so you have
 * to set your classpaths like this:
 * <pre>
 *   D:/projects/myapplication/src/
 *   D:/libraries/as2lib/main/src/
 * </pre>
 * 
 * <p>The MTASC compiler works the opposite way. The topmost classpath is less important.
 * So you have to set your classpaths like this:
 * <pre>-cp "D:/libraries/as2lib/main/src/" -cp "D:/projects/myapplication/src/"</pre>
 * 
 * <p>If you work with the ASDT eclipse plugin that uses mtasc you have to set the classpaths
 * in your project directory as you do for MTASC (you can add external folders by using alias
 * folders).
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class main.Configuration extends BasicClass {
	
	/**
	 * Configures and starts the application.
	 */
	public function init(Void):Void {
		// do common configuration
		// start the application
	}
	
}