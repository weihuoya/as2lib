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
 
import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.out.RootOut extends Out {
	
	/**
	 * Constructs a new RootOut instance. The name will be automatically
	 * set to 'root'.
	 *
	 * @param level an OutLevel instance, null is not allowed
	 */
	public function RootOut(level:OutLevel) {
		super("root");
		setLevel(level);
	}
	
	/**
	 * Does the same as the Out#setLevel() operation but prevents null levels.
	 *
	 * @param level the OutLevel to use, null is not allowed
	 * @throws IllegalArgumentException when you try to set a level with value null
	 */
	public function setLevel(level:OutLevel):Void {
		if (!level) throw new IllegalArgumentException("The RootOut instance is not allowed to have a level value of null.", this, arguments);
		super.setLevel(level);
	}
	
}