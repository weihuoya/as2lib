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
 
 import org.as2lib.env.except.Throwable;
 import org.as2lib.env.except.IllegalStateException;
 import org.as2lib.env.except.TAbstractThrowable;
 
/**
 * @author Jayaprakash A
 */
class org.as2lib.env.except.TIllegalStateException extends TAbstractThrowable{
	
	public function  TIllegalStateException(Void){
	}

	public function getThrowable(message:String, thrower, args:FunctionArguments):Throwable {
		return new IllegalStateException(message, thrower, args);
	}
	
}