import org.aswing.Component;
/*
 * Copyright (c) 2005, xlands.com inc.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 * 
 * 1) Redistributions of source code must retain the above copyright notice, 
 *    this list of conditions and the following disclaimer.
 *  
 * 2) Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution. 
 * 
 * 3) Neither the name of xlands.com inc. nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without specific
 *    prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 */
/**
 *
 * @author iiley
 */
interface org.aswing.Resizer {
	public function setOwner(c:Component):Void;
	
	public function createTo(mc:MovieClip):Void;
		
	/**
	 * <p>Indicate whether need resize component directly when drag the resizer arrow.
	 * <p>if set to false, there will be a rectange to represent then size what will be resized to.
	 * <p>if set to true, the component will be resize directly when drag, but this is need more cpu counting.
	 * <p>Default is false.
	 * @see org.aswing.JFrame
	 */	
	public function setResizeDirectly(r:Boolean):Void;
	
	/**
	 * Returns whether need resize component directly when drag the resizer arrow.
	 * @see #setResizeDirectly
	 */
	public function isResizeDirectly():Boolean;
	
	public function isEnabled():Boolean;
	
	public function setEnabled(b:Boolean):Void;
}