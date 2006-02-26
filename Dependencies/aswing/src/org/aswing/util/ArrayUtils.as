/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 

 
/**
 * Utils functions about Array.
 * @author iiley
 */
class org.aswing.util.ArrayUtils {
	/**
	 * Call the operation by pass each element of the array once.
	 * <p>
	 * for example:
	 * <pre>
	 * //hide all component in vector components
	 * ArrayUtils.each( 
	 *     components,
	 *     function(c:Component){
	 *         c.setVisible(false);
	 *     });
	 * <pre>
	 * @param arr the array for each element will be operated.
	 * @param the operation function for each element
	 * @see Vector#each
	 */
	public static function each(arr:Array, operation:Function):Void{
		for(var i:Number=0; i<arr.length; i++){
			operation(arr[i]);
		}
	}
	
	public static function removeFromArray(arr:Array, obj:Object):Void{
		for(var i:Number=0; i<arr.length; i++){
			if(arr[i] == obj){
				arr.splice(i, 1);
				return;
			}
		}
	}
	
	public static function removeAllFromArray(arr:Array, obj:Object):Void{
		for(var i:Number=0; i<arr.length; i++){
			if(arr[i] == obj){
				arr.splice(i, 1);
				i--;
			}
		}
	}
	
	public static function removeAllBehindSomeIndex(array:Array , index:Number):Void{
		if(index <= 0){
			array.splice(0, array.length);
			return;
		}
		var arrLen:Number = array.length;
		for(var i:Number=index+1 ; i<arrLen ; i++){
			array.pop();
		}
	}	
	
	public static function indexInArray(arr:Array, obj:Object):Number{
		for(var i:Number=0; i<arr.length; i++){
			if(arr[i] == obj){
				return i;
			}
		}
		return -1;
	}
	
	public static function cloneArray(arr:Array):Array{
		return arr.concat();
	}
}
