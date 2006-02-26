/* See LICENSE for copyright and terms of use */

import org.actionstep.ASUtils;
import org.actionstep.binding.ASBindingDescriptor;
import org.actionstep.constants.NSBindingDescription;
import org.actionstep.controllers.NSController;
import org.actionstep.NSArray;
import org.actionstep.NSDictionary;
import org.actionstep.NSMenuItem;

/**
 * <code>NSObjectController</code> is a bindings compatible controller class. 
 * Properties of the content object of an instance of this class can be bound to
 * user interface elements to access and modify their values.
 * 
 * @author Scott Hyndman
 */
class org.actionstep.controllers.NSObjectController extends NSController {
	
	private static var g_exposedBindings:NSArray;
	
	private var m_content:Object;
	private var m_objectClass:Function;
	private var m_editable:Boolean;
	private var m_entityName:String;
	
	//******************************************************
	//*                  Construction
	//******************************************************
	
	/**
	 * Creates a new instance of the <code>NSObjectController</code> class.
	 */
	public function NSObjectController() {
		m_objectClass = NSDictionary;
		m_editable = true;
	}
	
	/**
	 * Initializes and returns an <code>NSObjectController</code> object with 
	 * the specified content.
	 */
	public function initWithContent(content:Object):NSObjectController {
		m_content = content;
		
		return this;
	}
	
	//******************************************************
	//*                Managing content
	//******************************************************
	
	/**
	 * Sets this controllers content to <code>content</code>.
	 */
	public function setContent(content:Object):Void {
		m_content = content;
	}
	
	/**
	 * Returns this controller's content.
	 */
	public function content():Object {
		return m_content;
	}
	
	//! TODO - (void)setAutomaticallyPreparesContent:(BOOL)flag
	//! TODO - (BOOL)automaticallyPreparesContent
	//! TODO - (void)prepareContent
	
	//******************************************************
	//*             Setting the content class
	//******************************************************
	
	/**
	 * Sets the object class used when creating new objects to
	 * <code>objectClass</code>.
	 * 
	 * <code>NSObjectController</code>’s default implementation assumes that 
	 * instances of <code>objectClass</code> are initialized using a standard 
	 * <code>#init</code> method that takes no arguments.
	 */
	public function setObjectClass(objectClass:Function):Void {
		m_objectClass = objectClass;
	}
	
	/**
	 * Returns the class used when creating new objects.
	 * 
	 * The default class is <code>NSDictionary</code>.
	 */
	public function objectClass():Function {
		return m_objectClass;
	}
	
	//******************************************************
	//*               Managing objects
	//******************************************************
	
	//! TODO -(NSManagedObjectContext *)managedObjectContext
	
	/**
	 * Creates and returns a new object of the class specified by 
	 * <code>#objectClass</code>.
	 */
	public function newObject():Object {
		var obj:Object = ASUtils.createInstanceOf(objectClass(), []);
		obj.init();
		
		return obj;
	}
	
	/**
	 * Sets <code>object</code> as the controller’s content object.
	 * 
	 * If the controller's content is bound to another object or controller 
	 * through a relationship key, the relationship of the 'master' object is 
	 * changed.
	 */
	public function addObject(object:Object):Void {
		//! TODO change relationship
		setContent(object);
	}
	
	/**
	 * If <code>object</code> is the controller’s content object, the 
	 * controller’s content is set to <code>null</code>.
	 * 
	 * If the controller's content is bound to another object or controller 
	 * through a relationship key, the relationship of the 'master' object is 
	 * cleared.
	 */
	public function removeObject(object:Object):Void {
		var equal:Boolean = false;
		
		if (ASUtils.respondsToSelector(object, "isEqual")) {
			equal = object.isEqual(content());
		} else {
			equal = object == content();
		}
		
		if (equal) {
			setContent(null);
		}
	}
	
	/**
	 * Creates a new object of the class specified by <code>#objectClass</code> 
	 * and sets it as the controller’s content object using 
	 * <code>#addObject</code>.
	 * 
	 * The <code>sender</code> is typically the object that invoked this method.
	 * 
	 * @see #canAdd
	 */
	public function add():Void {
		if (!canAdd()) {
			return;
		}
		
		addObject(newObject());
	}
	
	/**
	 * Returns <code>true</code> if an object can be added to the controller 
	 * using <code>#add</code>.
	 */
	public function canAdd():Boolean {
		return m_editable;
	}
	
	/**
	 * Removes the controller’s content object using <code>#removeObject</code>.
	 */
	public function remove():Void {
		if (!canRemove()) {
			return;
		}
		
		removeObject(content());
	}
	
	/**
	 * Returns <code>true</code> if an object can be removed from the controller 
	 * using <code>#remove</code>.
	 */
	public function canRemove():Boolean {
		return m_editable;
	}
	
	//******************************************************
	//*               Managing entity names
	//******************************************************
	
	/**
	 * Returns the entity name used by the controller to create new objects.
	 */
	public function entityName():String {
		return m_entityName;
	}
	
	/**
	 * Sets the controller’s entity name to <code>entityName</code>.
	 */
	public function setEntityName(entityName:String):Void {
		m_entityName = entityName;
	}
	
	//******************************************************
	//*                 Managing editing
	//******************************************************
	
	/**
	 * Sets whether the controller allows adding and removing objects.
	 * 
	 * The default is <code>true</code>.
	 */
	public function setEditable(flag:Boolean):Void {
		m_editable = flag;
	}
	
	/**
	 * Returns <code>true</code> if the controller allows adding and removing 
	 * objects.
	 */
	public function isEditable():Boolean {
		return m_editable;
	}
	
	//******************************************************
	//*              Managing fetch predicates
	//******************************************************
	
	//! TODO -(void)setFetchPredicate:(NSPredicate *)predicate
	//! TODO -(NSPredicate *)fetchPredicate
	
	//******************************************************
	//*             Core Data object contexts
	//******************************************************
	
	//! TODO - (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
	//! TODO -(void)fetch:(id)sender
	//! TODO - (BOOL)fetchWithRequest:(NSFetchRequest *)fetchRequest merge:(BOOL)merge error:(NSError **)error
	
	//******************************************************
	//*                Obtaining selections
	//******************************************************
	
	/**
	 * Returns an array of all objects to be affected by editing.
	 * 
	 * This property is observable using key-value observing.
	 */
	public function selectedObjects():NSArray {
		return NSArray.arrayWithObject(content());
	}
	
	/**
	 * Returns a proxy object representing the controller’s selection.
	 * 
	 * This property is observable using key-value observing.
	 */
	public function selection():Object {
		//! FIXME Make this work
		return null;
	}
	
	//******************************************************
	//*               Validating menu items
	//******************************************************
	
	/**
	 * Validates menu item <code>anItem</code>, returning <code>true</code> if 
	 * it should be enabled, <code>false</code> otherwise.
	 * 
	 * For example, if <code>#canAdd</code> returns <code>false</code>, menu 
	 * items with the <code>#add</code> action and this controller as the target 
	 * object are disabled.
	 */
	public function validateMenuItem(anItem:NSMenuItem):Boolean {
		var targ:Object = anItem.target();
		var action:String = anItem.action();
		
		if (targ != this) {
			return true;
		}
		
		switch (action) {
			case "add":
				return canAdd();
				break;
				
			case "remove":
				return canRemove();
				break;
				
		}
		
		return true;
	}
	
	//******************************************************
	//*              NSKeyValueBindingCreation
	//******************************************************
	
	/**
	 * Returns the bindings exposed by this class.
	 */
	public static function exposedBindingsForClass():NSArray {
		return g_exposedBindings;
	}
	
	//******************************************************
	//*                Static construction
	//******************************************************
	
	/**
	 * Initializes the class.
	 */
	private static function initialize():Void {
		g_exposedBindings = new NSArray();
		
		g_exposedBindings.addObject(
			ASBindingDescriptor.bindingDescriptorWithDescriptionReadOnlyOptions(
				NSBindingDescription.NSEditableBinding,
				true,
				null
			));
			
		g_exposedBindings.addObject(
			ASBindingDescriptor.bindingDescriptorWithDescriptionReadOnlyOptions(
				NSBindingDescription.NSContentObjectBinding,
				false,
				null
			));
			
		//! TODO managedObjectContext
	}
}