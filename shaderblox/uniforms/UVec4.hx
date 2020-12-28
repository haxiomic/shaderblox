package shaderblox.uniforms;

import webgl.GLContext;
import webgl.GLUniformLocation;
import typedarray.Float32Array;

abstract Vec4(Float32Array) to Float32Array from Float32Array {

	public var x(get, set): Float;
	public var y(get, set): Float;
	public var z(get, set): Float;
	public var w(get, set): Float;
	
	inline public function new(x: Float = 0, y: Float = 0, z: Float = 0, w: Float = 0){
		this = new Float32Array(4);
		set_x(x);
		set_y(y);
		set_z(z);
		set_w(w);
	}

	inline public function set(x: Float, y: Float, z: Float, w: Float){
		set_x(x);
		set_y(y);
		set_z(z);
		set_w(w);
	}

	inline function get_x() return this[0];
	inline function set_x(v: Float) return this[0] = v;

	inline function get_y() return this[1];
	inline function set_y(v: Float) return this[1] = v;

	inline function get_z() return this[2];
	inline function set_z(v: Float) return this[2] = v;

	inline function get_w() return this[3];
	inline function set_w(v: Float) return this[3] = v;

}

/**
 * Vector4 float uniform
 * @author Andreas Rønning
 */

@:keepSub
class UVec4 extends UniformBase<Vec4> implements IAppliable  {
	public function new(gl: GLContext, name:String, index:GLUniformLocation, x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) {
		super(gl, name, index, new Vec4(x, y, z, w));
	}
	public inline function apply():Void {
		gl.uniform4f(location, data.x, data.y, data.z, data.w);
		dirty = false;
	}
}