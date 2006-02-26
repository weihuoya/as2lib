/*
 Copyright aswing.org, see the LICENCE.txt.
*/

/**
 * DepthManager to manage the depth of mcs created by AS.
 * 
 * <p>This Manager can not manage the mcs created by FlashIDE.
 * 
 * @author iiley
 */
class org.aswing.util.DepthManager{
	public static var MAX_DEPTH:Number = 1048575;
	public static var MIN_DEPTH:Number = 0;
	
	/**
	 * bringToBottom(mc:MovieClip, exceptMC:MovieClip)<br>
	 * bringToBottom(mc:MovieClip)
	 * <p>
	 * Bring the mc to all brother mcs' bottom.
	 * <p>
	 * if exceptMC is undefined or null, the mc will be sent to bottom of all.
	 * else, the mc will be sent to the bottom of all but above the exceptMC.
	 * If you use a exceptMC, make sure the exceptMC is always at the bottom of all mcs, unless, this 
	 * method maybe weird(may throw Errors).
	 * @param mc the mc to be set to bottom
	 * @param exceptMC the exceptMC of bottom mc.
	 * @see #isBottom()
	 * @throws Error when the exceptMC is not at the bottom currently.
	 */
	public static function bringToBottom(mc:MovieClip, exceptMC:MovieClip):Void{
		var parent:MovieClip = mc._parent;
		if(parent == null) return;
		if(mc.getDepth() == MIN_DEPTH) return;
		
		var minDepth:Number = (exceptMC == undefined ? MIN_DEPTH : exceptMC.getDepth()+1);
		
		if(parent.getInstanceAtDepth(minDepth) == undefined){
			mc.swapDepths(minDepth);
			return;
		}
		
		var mcs:Array = createMCSequenced(parent);
		if(mc == mcs[0]) return;
		if(mc == mcs[1] && exceptMC == mcs[0]) return;
		
		if(exceptMC != mcs[0]){
			trace("The exceptMC is not at the bottom currently!");
			throw new Error("The exceptMC is not at the bottom currently!");
		}
		
		var swapMC:MovieClip = mc;
		for(var i:Number=1; mcs[i]!=mc; i++){
			swapMC.swapDepths(mcs[i]);
			swapMC = mcs[i];
		}
	}
	
	/**
	 * Bring the mc to all brother mcs' top.
	 */	
	public static function bringToTop(mc:MovieClip):Void{
		var parent:MovieClip = mc._parent;
		if(parent == null) return;
		var depth:Number = parent.getNextHighestDepth();
		if(mc.getDepth() == (depth - 1)) return;
		if(depth < MAX_DEPTH){
			mc.swapDepths(depth);
			return;
		}
		
		var mcs:Array = createMCSequenced(parent);
		if(mc == mcs[0]) return;
		
		var swapMC:MovieClip = mc;
		for(var i:Number=mcs.length-1; mcs[i]!=mc; i--){
			swapMC.swapDepths(mcs[i]);
			swapMC = mcs[i];
		}		
	}
	
	/**
	 * Returns is the mc is on the top depths in DepthManager's valid depths.
	 * Valid depths is that depths from MIN_DEPTH to MAX_DEPTH.
	 */
	public static function isTop(mc:MovieClip):Boolean{
		var parent:MovieClip = mc._parent;
		if(parent == null) return true;
		var depth:Number = parent.getNextHighestDepth();
		return mc.getDepth() == (depth - 1);
	}
	
	/**
	 * isBottom(mc:MovieClip, exceptMC:MovieClip)<br>
	 * isBottom(mc:MovieClip)
	 * <p>
	 * Returns is the mc is at the bottom depths in DepthManager's valid depths.
	 * Valid depths is that depths from MIN_DEPTH to MAX_DEPTH.
	 * <p>
	 * if exceptMC is undefined or null, judge is the mc is at bottom of all.
	 * else, the mc judge is the mc is at bottom of all except the exceptMC.
	 * @param mc the mc to be set to bottom
	 * @param exceptMC the exceptMC of bottom mc.
	 * @return is the mc is at the bottom
	 */
	public static function isBottom(mc:MovieClip, exceptMC:MovieClip):Boolean{
		var parent:MovieClip = mc._parent;
		if(parent == null) return true;
		var depth:Number = mc.getDepth();
		if(depth == MIN_DEPTH){
			return true;
		}
		for(var i:Number=MIN_DEPTH; i<depth; i++){
			var mcAtDepth:MovieClip = parent.getInstanceAtDepth(i);
			if(mcAtDepth != undefined && mcAtDepth != exceptMC){
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Return if mc is just first bebow the aboveMC.
	 * if them don't have the same parent, whatever depth they has just return false.
	 */
	public static function isJustBelow(mc:MovieClip, aboveMC:MovieClip):Boolean{
		var parent:MovieClip = mc._parent;
		if(parent == null) return false;
		if(aboveMC._parent != parent) return false;
		
		if(mc.getDepth() >= aboveMC.getDepth()){
			return false;
		}else{
			for(var i:Number=aboveMC.getDepth() - 1; i>=MIN_DEPTH; i--){
				var t:MovieClip = parent.getInstanceAtDepth(i);
				if(t != null){
					if(t == mc){
						return true;
					}else{
						return false;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * Return if mc is just first above the belowMC.
	 * if them don't have the same parent, whatever depth they has just return false.
	 * @see #isJustBelow
	 */	
	public static function isJustAbove(mc:MovieClip, belowMC:MovieClip):Boolean{
		return isJustBelow(belowMC, mc);
	}
		
	/**
	 * Create a sequence contains all mcs sorted by their depth.
	 */
	public static function createMCSequenced(parent:MovieClip):Array{
		var mcs:Array = new Array();
		for(var i:String in parent){
			if(parent[i] instanceof MovieClip){
				mcs.push(parent[i]);
			}
		}
		mcs.sort(depthComparator);
		return mcs;
	}
	
	private static function depthComparator(a, b):Number{
		if(a.getDepth() > b.getDepth()){
			return -1;
		}else{
			return 1;
		}
	}
}
