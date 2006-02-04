/*
   Copyright 2004 Ralf Siegel

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
/**
*	@author Ralf Siegel
*/
class org.log4f.logging.errors.InvalidPublisherError extends Error
{
	public var name:String = "InvalidPublisherError";		
	public var message:String;

	public function InvalidPublisherError(className:String)
	{
		super();
		this.message = "'" + className + "' is not a valid Publisher";
	}
	
	public function toString():String
	{
		return "[" + this.name + "] " + this.message;
	}
}