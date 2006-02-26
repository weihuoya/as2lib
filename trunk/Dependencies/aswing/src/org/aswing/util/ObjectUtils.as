/*
 Copyright aswing.org, see the LICENCE.txt.
*/

/**
 * Utils about Object
 */
class org.aswing.util.ObjectUtils{
	public static function baseClone(existObject:Object):Object{
		if(existObject instanceof Object){
			var newObject:Object = new Object();
			for(var i:String in existObject){
				if(existObject[i] instanceof Object){
					newObject[i] = new Object();
					newObject[i] = baseClone(existObject[i]);
				}else{
					newObject[i] = existObject[i];
				}
			}
			return newObject;
		}else{
			return existObject;
		}
	}
}
