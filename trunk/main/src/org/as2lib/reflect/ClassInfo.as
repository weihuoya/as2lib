import org.as2lib.basic.TypedArray;

/**
 * Informationholder for the reflected Classinformation
 * This Interfaces defines the properties and possibilies to access
 * all informations that are stored using reflections.
 */

interface org.as2lib.basic.reflect.ClassInfo { 
      
     /** 
      * @returns the name from the class
      */ 
     public function getName(Void):String; 
     
     /** 
      * You may set the name for yourself to save performance.
      * If you set the name this way, reflections will be switched off.
      * This value won't get validated by an internal routine.
      *
      * @param name for this class
      */
     public function setName(to:String):Void;
     
     /** 
      * @returns the constructor from the class.
      */ 
     public function getConstructor(Void):Function; 
     
     /** 
      * @returns a new Instance from this constructor appending Arguments to the constructor.
      */ 
     public function newInstance(usedArguments:Array):Object; 
      
     /** 
      * Returns a TypedArray from type String containing all Vars that an Instance of this class has. 
      */ 
     public function getVars(Void):TypedArray; 
     
     /**
      * Overwrite the internal
      */
     public function setVars(to:TypedArray):Void;
     
     /** 
      * Returns a TypedArray from type MethodInfo containing all Methods that an Instance of this class has. 
      */ 
     public function getMethods(Void):TypedArray; 
     
     /**
      * TODO: Docu
      */
     public function setMethods(to:TypedArray):Void;
      
     /** 
      * Returns a TypedArray from type String containing all Vars that the Class has. 
      */ 
     public function getStaticVars(Void):TypedArray; 
     
     /**
      * TODO: Docu
      */
     public function setStaticVars(to:TypedArray):Void;
      
     /** 
      * Returns a TypedArray from type MethodInfo containing all Methods that the Class has. 
      */ 
     public function getStaticMethods(Void):TypedArray; 
     
     /**
      * TODO: Docu
      */
     public function setStaticMethods(to:TypedArray):Void;
 
} 