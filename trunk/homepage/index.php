<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "About";
  $homepageInfo->page = "weblog";
  $homepageInfo->path = "";
  include('header.inc.php');
?>
      <div id="sidebar">
        <div id="sidebarContent">
          <div class="contentArea">
            <h2>Links</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="#">MyLink1</a></li>
              <li><a href="#">MyLink2</a></li>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Links2</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="#">MyLink1</a></li>
              <li><a href="#">MyLink2</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div id="content">
        <div class="contentArea">
          <h2>About</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>About the as2lib</h3>
            asdfjasdölkfj asdlfj lkfj lsdkjf lödksfj lksdfj sdkjf sldjf slködjf asd
            sdfj asdkfj sdkölfj söladjf ksöldjf klsdfj lksödfjasljf lkadfjksdf jjsf 
            adsflk jsdkflj söladjf akslfj sakdfj asdklfj sdkfj sldkfj sdfj söldfj s
            asdfj sdfj sldfj lakdsfj lkadsfj lsddfj lsadjf ölsdf
            asdfsadfj asdöfl jadskflj sdlkfj asdkfj askfj jf saldjfsddf aökljdsfköljs
          </div>
          <div class="text">
            <h3>Team</h3>
            asdfjasdölkfj asdlfj lkfj lsdkjf lödksfj lksdfj sdkjf sldjf slködjf asd
            sdfj asdkfj sdkölfj söladjf ksöldjf klsdfj lksödfjasljf lkadfjksdf jjsf 
            adsflk jsdkflj söladjf akslfj sakdfj asdklfj sdkfj sldkfj sdfj söldfj s
            asdfj sdfj sldfj lakdsfj lkadsfj lsddfj lsadjf ölsdf
            asdfsadfj asdöfl jadskflj sdlkfj asdkfj askfj jf saldjfsddf aökljdsfköljs
          </div>
        </div>
        <div class="contentArea">
          <h2>About</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>About the as2lib</h3>
            asdfjasdölkfj asdlfj lkfj lsdkjf lödksfj lksdfj sdkjf sldjf slködjf asd
            sdfj asdkfj sdkölfj söladjf ksöldjf klsdfj lksödfjasljf lkadfjksdf jjsf 
            adsflk jsdkflj söladjf akslfj sakdfj asdklfj sdkfj sldkfj sdfj söldfj s
            asdfj sdfj sldfj lakdsfj lkadsfj lsddfj lsadjf ölsdf
            asdfsadfj asdöfl jadskflj sdlkfj asdkfj askfj jf saldjfsddf aökljdsfköljs
          </div>
          <div class="text">
            <h3>Team</h3>
            asdfjasdölkfj asdlfj lkfj lsdkjf lödksfj lksdfj sdkjf sldjf slködjf asd
            sdfj asdkfj sdkölfj söladjf ksöldjf klsdfj lksödfjasljf lkadfjksdf jjsf 
            adsflk jsdkflj söladjf akslfj sakdfj asdklfj sdkfj sldkfj sdfj söldfj s
            <pre class="as2"><span class="style0">/*
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
 */</span><br /><br /><span class="style6">import</span> <span class="style8">org</span><span class="style7">.</span><span class="style8">as</span><span class="style3">2</span><span class="style8">lib</span><span class="style7">.</span><span class="style8">util</span><span class="style7">.</span><span class="style8">ObjectUtil</span><span class="style7">;</span><br /><span class="style6">import</span> <span class="style8">org</span><span class="style7">.</span><span class="style8">as</span><span class="style3">2</span><span class="style8">lib</span><span class="style7">.</span><span class="style8">core</span><span class="style7">.</span><span class="style8">BasicInterface</span><span class="style7">;</span><br /><span class="style6">import</span> <span class="style8">org</span><span class="style7">.</span><span class="style8">as</span><span class="style3">2</span><span class="style8">lib</span><span class="style7">.</span><span class="style8">env</span><span class="style7">.</span><span class="style8">except</span><span class="style7">.</span><span class="style8">IllegalArgumentException</span><span class="style7">;</span><br /><span class="style6">import</span> <span class="style8">org</span><span class="style7">.</span><span class="style8">as</span><span class="style3">2</span><span class="style8">lib</span><span class="style7">.</span><span class="style8">env</span><span class="style7">.</span><span class="style8">util</span><span class="style7">.</span><span class="style8">ReflectUtil</span><span class="style7">;</span><br /><span class="style6">import</span> <span class="style8">org</span><span class="style7">.</span><span class="style8">as</span><span class="style3">2</span><span class="style8">lib</span><span class="style7">.</span><span class="style8">env</span><span class="style7">.</span><span class="style8">reflect</span><span class="style7">.</span><span class="style8">ClassInfo</span><span class="style7">;</span><br /><br /><span class="style0">/**
 * Acts like a normal Array but assures that only objects from one and the same
 * type are added to the Array.
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 */</span><br /><span class="style6">class</span> <span class="style8">org</span><span class="style7">.</span><span class="style8">as</span><span class="style3">2</span><span class="style8">lib</span><span class="style7">.</span><span class="style5">data</span><span class="style7">.</span><span class="style8">holder</span><span class="style7">.</span><span class="style8">TypedArray</span> <span class="style6">extends</span> <span class="style2">Array</span> <span class="style6">implements</span> <span class="style8">BasicInterface</span> <span class="style7">{</span><br />	<span class="style0">/*public static var CASEINSENSITIVE = Array.CASEINSENSITIVE;
	public static var DESCENDING = Array.DESCENDING;
	public static var NUMERIC = Array.NUMERIC;
	public static var RETURNINDEXDARRAY = Array.RETURNINDEXEDARRAY;
	public static var UNIQUESORT = Array.UNIQUESORT;*/</span><br />	<br />	<span class="style0">/** The Array the TypedArray wraps. */</span><br />	<span class="style6">private</span> <span class="style5">var</span> <span class="style8">array</span><span class="style7">:</span><span class="style2">Array</span><span class="style7">;</span><br />	<br />	<span class="style0">/** The type of values that can be added. */</span><br />	<span class="style6">private</span> <span class="style5">var</span> <span class="style5">type</span><span class="style7">:</span><span class="style2">Function</span><span class="style7">;</span><br />	<br />	<span class="style0">/**
	 * Constructs a new TypedArray instance.
	 *
	 * @param type the type of the values this TypedArray contains
	 * @param array the Array that shall be wrapped
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style8">TypedArray</span><span class="style7">(</span><span class="style5">type</span><span class="style7">:</span><span class="style2">Function</span><span class="style7">,</span> <span class="style8">array</span><span class="style7">:</span><span class="style2">Array</span><span class="style7">)</span> <span class="style7">{</span><br />		<span class="style5">this</span><span class="style7">.</span><span class="style5">type</span> <span class="style7">=</span> <span class="style5">type</span><span class="style7">;</span><br />		<span class="style5">this</span><span class="style7">.</span><span class="style8">array</span> <span class="style7">=</span> <span class="style8">array</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">concat</span><span class="style7">(</span><span class="style7">)</span><span class="style7">:</span><span class="style8">TypedArray</span> <span class="style7">{</span><br />		<span class="style5">var</span> <span class="style8">l</span><span class="style7">:</span><span class="style2">Number</span> <span class="style7">=</span> <span class="style5">arguments</span><span class="style7">.</span><span class="style5">length</span><span class="style7">;</span><br />		<span class="style5">for</span> <span class="style7">(</span><span class="style5">var</span> <span class="style8">i</span><span class="style7">:</span><span class="style2">Number</span> <span class="style7">=</span> <span class="style3">0</span><span class="style7">;</span> <span class="style8">i</span> <span class="style7">&lt;</span> <span class="style8">l</span><span class="style7">;</span> <span class="style8">i</span><span class="style7">+</span><span class="style7">+</span><span class="style7">)</span> <span class="style7">{</span><br />			<span class="style8">validate</span><span class="style7">(</span><span class="style5">arguments</span><span class="style7">[</span><span class="style8">i</span><span class="style7">]</span><span class="style7">)</span><span class="style7">;</span><br />		<span class="style7">}</span><br />		<span class="style5">var</span> <span class="style8">result</span><span class="style7">:</span><span class="style8">TypedArray</span><span class="style7">;</span><br />		<span class="style5">if</span> <span class="style7">(</span><span class="style8">l</span> <span class="style7">=</span><span class="style7">=</span> <span class="style3">0</span><span class="style7">)</span> <span class="style7">{</span><br />			<span class="style8">result</span> <span class="style7">=</span> <span class="style5">new</span> <span class="style8">TypedArray</span><span class="style7">(</span><span class="style5">this</span><span class="style7">.</span><span class="style5">type</span><span class="style7">,</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">concat</span><span class="style7">(</span><span class="style7">)</span><span class="style7">)</span><span class="style7">;</span><br />		<span class="style7">}</span> <span class="style5">else</span> <span class="style7">{</span><br />			<span class="style8">result</span> <span class="style7">=</span> <span class="style5">new</span> <span class="style8">TypedArray</span><span class="style7">(</span><span class="style5">this</span><span class="style7">.</span><span class="style5">type</span><span class="style7">,</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">concat</span><span class="style7">(</span><span class="style5">arguments</span><span class="style7">)</span><span class="style7">)</span><span class="style7">;</span><br />		<span class="style7">}</span><br />		<span class="style6">return</span> <span class="style8">result</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * Checks if the array already contains the passed object.
	 *
	 * @param object the object that shall be checked for availability
	 * @return true if the array contains the object else false
	 */</span><br />	<span class="style0">/*public function contains(object):Boolean {
		var l:Number = array.length;
		for (var i:Number = 0; i < l; i++) {
			if (array[i] === object) {
				return true;
			}
		}
		return false;
	}*/</span><br />	<br />	<span class="style0">/**
	 * Removes all content out of the TypedArray.
	 *
	 * @param 
	 */</span><br />	<span class="style0">/*public function clear(Void):Void {
		array = new Array();
	}*/</span><br />	<br />	<span class="style0">/**
	 * Sets the new value at the given position.
	 * @param number
	 * @param value
	 */</span><br />	<span class="style0">/*public function setValue(number:Number, value):Void {
		this.array[number] = value;
	}*/</span><br />	<br />	<span class="style0">/**
	 * Gets the value associated with the given number.
	 * @param number
	 * @return the value
	 */</span><br />	<span class="style0">/*public function getValue(number:Number) {
		return this.array[number];
	}*/</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">join</span><span class="style7">(</span><span class="style8">seperator</span><span class="style7">:</span><span class="style2">String</span><span class="style7">)</span><span class="style7">:</span><span class="style2">String</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">join</span><span class="style7">(</span><span class="style8">seperator</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">pop</span><span class="style7">(</span><span class="style2">Void</span><span class="style7">)</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">pop</span><span class="style7">(</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">push</span><span class="style7">(</span><span class="style5">value</span><span class="style7">)</span><span class="style7">:</span><span class="style2">Number</span> <span class="style7">{</span><br />		<span class="style8">validate</span><span class="style7">(</span><span class="style5">value</span><span class="style7">)</span><span class="style7">;</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">push</span><span class="style7">(</span><span class="style5">value</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">reverse</span><span class="style7">(</span><span class="style2">Void</span><span class="style7">)</span><span class="style7">:</span><span class="style2">Void</span> <span class="style7">{</span><br />		<span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">reverse</span><span class="style7">(</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">shift</span><span class="style7">(</span><span class="style2">Void</span><span class="style7">)</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">shift</span><span class="style7">(</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">sort</span><span class="style7">(</span><span class="style7">)</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">sort</span><span class="style7">.</span><span class="style6">apply</span><span class="style7">(</span><span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">,</span> <span class="style5">arguments</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br /><br />	 <span class="style6">public</span> <span class="style6">function</span> <span class="style6">sortOn</span><span class="style7">(</span><span class="style7">)</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">sortOn</span><span class="style7">.</span><span class="style6">apply</span><span class="style7">(</span><span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">,</span> <span class="style5">arguments</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">splice</span><span class="style7">(</span><span class="style5">index</span><span class="style7">:</span><span class="style2">Number</span><span class="style7">,</span> <span class="style8">count</span><span class="style7">:</span><span class="style2">Number</span><span class="style7">)</span><span class="style7">:</span><span class="style2">Void</span> <span class="style7">{</span><br />		<span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">splice</span><span class="style7">.</span><span class="style6">apply</span><span class="style7">(</span><span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">,</span> <span class="style5">arguments</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">unshift</span><span class="style7">(</span><span class="style5">value</span><span class="style7">)</span><span class="style7">:</span><span class="style2">Number</span> <span class="style7">{</span><br />		<span class="style8">validate</span><span class="style7">(</span><span class="style5">value</span><span class="style7">)</span><span class="style7">;</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style6">unshift</span><span class="style7">(</span><span class="style5">value</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @return the type of the array
	 */</span><br />	<span class="style0">/*public function getType(Void):Function {
		return this.type;
	}*/</span><br />	<br />	<span class="style0">/**
	 * @see Array
	 */</span><br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">get</span> <span class="style5">length</span><span class="style7">(</span><span class="style7">)</span><span class="style7">:</span><span class="style2">Number</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style5">this</span><span class="style7">.</span><span class="style8">array</span><span class="style7">.</span><span class="style5">length</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * @see #length
	 */</span><br />	<span class="style0">/*public function getLength():Number {
		return this.length;
	}*/</span><br />	<br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style8">getClass</span><span class="style7">(</span><span class="style2">Void</span><span class="style7">)</span><span class="style7">:</span><span class="style8">ClassInfo</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style8">ReflectUtil</span><span class="style7">.</span><span class="style8">getClassInfo</span><span class="style7">(</span><span class="style5">this</span><span class="style7">)</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style6">public</span> <span class="style6">function</span> <span class="style6">toString</span><span class="style7">(</span><span class="style2">Void</span><span class="style7">)</span><span class="style7">:</span><span class="style2">String</span> <span class="style7">{</span><br />		<span class="style6">return</span> <span class="style1">&quot;&quot;</span><span class="style7">;</span><br />	<span class="style7">}</span><br />	<br />	<span class="style0">/**
	 * Checks if the object is of correct type.
	 *
	 * @param object the object that shall be type checked
	 * @throws 
	 */</span><br />	<span class="style0">/**
	 * Validates the passed object based on its type.
	 *
	 * @param object the object which type shall be validated
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */</span><br />	<span class="style6">private</span> <span class="style6">function</span> <span class="style8">validate</span><span class="style7">(</span><span class="style8">object</span><span class="style7">)</span><span class="style7">:</span><span class="style2">Void</span> <span class="style7">{</span><br />		<span class="style5">if</span> <span class="style7">(</span><span class="style7">!</span><span class="style8">ObjectUtil</span><span class="style7">.</span><span class="style8">typesMatch</span><span class="style7">(</span><span class="style8">object</span><span class="style7">,</span> <span class="style5">type</span><span class="style7">)</span><span class="style7">)</span> <span class="style7">{</span><br />			<span class="style6">throw</span> <span class="style5">new</span> <span class="style8">IllegalArgumentException</span><span class="style7">(</span><span class="style1">&quot;Type mismatch between [&quot;</span> <span class="style7">+</span> <span class="style8">object</span> <span class="style7">+</span> <span class="style1">&quot;] and [&quot;</span> <span class="style7">+</span> <span class="style5">type</span> <span class="style7">+</span> <span class="style1">&quot;].&quot;</span><span class="style7">)</span><span class="style7">;</span><br />		<span class="style7">}</span><br />	<span class="style7">}</span><br /><span class="style7">}</span>
</pre>
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>
