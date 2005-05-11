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

/**
 * {@code Configuration} ist open for your configuration at startup.
 * <p>{@code Configuration} is a central part of a configuration system. It should contain only the
 * non-plattform-specific configuration. If you want to use this configuration take a look at {@link org.as2lib.app.conf.FlashoutApplication},
 * {@link org.as2lib.app.conf.MtascApplication} or {@link org.as2lib.app.conf.FlashApplication}.
 * 
 * <p>{@code Configuration} is built for overwriting. Other classes reference to it but itself contains
 * no code. If you want to overwrite it you can create the same class in your directory with
 * your code. Here is an example:
 * <code>
 *   import com.domain.app.*;
 *   
 *   class main.Configuration {
 *     public static var app:MyApplication;
 *   
 *     public static function init(Void);Void {
 *       app = new MySuperApplication();
 *       app.start();
 *     }
 *   }
 * </code>
 * Its important to have a static init method, but that it. You can extend any class you like and define any method.
 * 
 * <p>If you now want to use this class in a Mtasc 
 * 
 * <p>You have to watch out for the compiler paths to get it run!
 * <br>The MM Flash 2004 compiler takes the topmost as most important so you would have to set your classpaths like:
 * <pre>
 *   D:\Projects\MyApplication\src\
 *   D:\Libraries\as2lib\main\src\
 * </pre>
 * <br>The MTASC compiler (available at http://mtasc.org) works directly opposed: The tompost classpath is less important. So you would have to set
 * your compiler path like <pre>-cp "D:/Libraries/as2lib/main/src" -cp "D:/Projects/MyApplication/src/"</pre>
 * <br>If you work with the eclipse plugin (available at http://asdt.sf.net) that works with mtasc you have to set the classpaths in your project
 * directory in the same way(you can add external folders by using alias folders).
 * 
 * @see org.as2lib.app.conf.FlashApplication
 * @see org.as2lib.app.conf.MtascApplication
 * @see org.as2lib.app.conf.FlashoutApplication
 * @author Martin Heidegger
 * @version 1.0
 */
class main.Configuration {
	
	/**
	 * Method to be used by {@link org.as2lib.app.conf.FlashoutApplication}, {@link org.as2lib.app.conf.FlashApplication}, {@link org.as2lib.app.conf.MtascApplication}
	 * in their init/main method. 
	 */
	public static function init(Void):Void {}
}