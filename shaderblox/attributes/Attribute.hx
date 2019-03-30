package shaderblox.attributes;

import gluon.es2.GLContext.DataType;
/**
 * Base attribute type with byte size, program location and attribute name
 * @author Andreas Rønning
 */
class Attribute
{
	public var byteSize:Int;
	public var itemCount:Int;
	public var location:Int;
	public var name:String;
	public var type: DataType;
}