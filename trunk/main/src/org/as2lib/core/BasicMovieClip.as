﻿/*
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
import org.as2lib.Config;

/**
 * BasicMovieClip is the basic class for movieclips with default implementations
 * of the functionalities declared by the BasicInterface.
 *
 * @see org.as2lib.core.BasicClass
 * @author Martin Heidegger
 */
class org.as2lib.core.BasicMovieClip extends MovieClip implements BasicInterface {

	/**
	 * Returns a string representation of this instance.
	 *
	 * <p>The string representation is obtained via the stringifier returned
	 * by the Config#getObjectStringifier method.
	 *
	 * @return teh string representation of this instance
	 */
	public function toString(Void):String {
		return Config.getObjectStringifier().execute(this);
	}
	
}