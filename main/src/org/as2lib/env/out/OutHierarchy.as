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
 
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.util.StringUtil;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.out.OutRepository;
import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutFactory;
import org.as2lib.env.out.DefaultOutFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.out.OutHierarchy extends BasicClass implements OutRepository {
	
	/** Stores already retrieved Out instances by name. */
	private var outs:Map;
	
	/** Stores the root out instance of the hierachy. */
	private var root:Out;
	
	/** This factory is used when no custom factory is specified. */
	private var defaultFactory:OutFactory;
	
	/**
	 * Constructs a new OutHierachy instance.
	 */
	public function OutHierarchy(root:Out) {
		this.root = root;
		outs = new PrimitiveTypeMap();
	}
	
	/**
	 * Returns either the OutFactory set via #setDefaultFactory() or the
	 * default DefaultOutFactory.
	 *
	 * @return the OutFactory used as default
	 */
	public function getDefaultFactory(Void):OutFactory {
		if (!defaultFactory) defaultFactory = new DefaultOutFactory();
		return defaultFactory;
	}
	
	/**
	 * Sets the OutFactory used when no custom OutFactory is specified in
	 * the #getOut() operation.
	 *
	 * @param defaultFactory the OutFactory to be used as default
	 */
	public function setDefaultFactory(defaultFactory:OutFactory):Void {
		this.defaultFactory = defaultFactory;
	}
	
	/**
	 * @see OutRepository#getOut()
	 */
	public function getOut():Out {
		var o:Overload = new Overload(this);
		o.addHandler([String], getOutByName);
		o.addHandler([String, OutFactory], getOutByNameAndFactory);
		return o.forward(arguments);
	}
	
	/**
	 * @see OutRepository#getOutByName()
	 */
	public function getOutByName(name:String):Out {
		return getOutByNameAndFactory(name, getDefaultFactory());
	}
	
	/**
	 * @see OutRepository#getOutByNameAndFactory()
	 */
	public function getOutByNameAndFactory(name:String, factory:OutFactory):Out {
		var result = outs.get(name);
		if (!result) {
			result = factory.createOut(name);
			outs.put(name, result);
			updateParents(result);
		} else if (result instanceof Array) {
			var children:Array = result;
			result = factory.createOut(name);
			outs.put(name, result);
			updateChildren(children, result);
			updateParents(result);
		}
		return result;
	}
	
	/**
	 * Updates the affected parents.
	 *
	 * @param out the newly added Out instance
	 */
	private function updateParents(out:Out):Void {
		var name:String = out.getName();
		var parentFound:Boolean = false;
		var length:Number = name.length;
		for (var i:Number = name.lastIndexOf(".", length-1); i >= 0; i = name.lastIndexOf(".", i-1)) {
			var substring:String = name.substring(0, i);
			var object = outs.get(substring);
			if (!object) {
				outs.put(substring, [out]);
			} else if (object instanceof Out) {
				parentFound = true;
				out.setParent(object);
				break;
			} else if (object instanceof Array) {
				object.push(out);
			} else {
				throw new IllegalStateException("Obtained object [" + object + "] is of an unexpected type.", this, arguments);
			}
		}
		if (!parentFound) out.setParent(root);
	}
	
	/**
	 * Updates the affected children of the Node.
	 *
	 * @param array the Array that contains the children to update
	 * @param out the Out instance that now replaces the node
	 */
	private function updateChildren(children:Array, out:Out):Void {
		var length:Number = children.length;
		for (var i:Number = 0; i < length; i++) {
			var child:Out = children[i];
			if (!StringUtil.startsWith(child.getParent().getName(), out.getName())) {
				out.setParent(child.getParent());
				child.setParent(out);
			}
		}
	}
	
	/**
	 * @see OutRepository#getRootOut()
	 */
	public function getRootOut(Void):Out {
		return root;
	}
	
}