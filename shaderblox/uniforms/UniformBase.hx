package shaderblox.uniforms;

import webgl.GLContext;
import webgl.GLUniformLocation;

/**
 * Generic uniform type
 * @author Andreas Rønning
 */

@:generic
@:remove 
class UniformBase<T> {
	var gl: GLContext;
	public var name:String;
	public var location:GLUniformLocation;
	public var data(default, set):T;
	public var dirty:Bool;
	public var alwaysDirty: Bool = false;
	function new(gl: GLContext, name:String, index:GLUniformLocation, data:T) {
		this.gl = gl;
		this.name = name;
		this.location = index;
		this.data = data;
	}
	public inline function set(data:T):T {
		return this.data = data;
	}
	public inline function setDirty() {
		dirty = true;
	}
	inline function set_data(data:T):T{
		setDirty();
		return this.data = data;
	}
}