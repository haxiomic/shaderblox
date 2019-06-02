package shaderblox.uniforms;

import gluon.es2.GLContext;
import gluon.es2.GLUniformLocation;
import typedarray.Float32Array;

/**
 * Vector3 float uniform
 * @author Andreas Rønning
 */
abstract Vec3(Float32Array) to Float32Array from Float32Array {

	public var x(get, set): Float;
	public var y(get, set): Float;
	public var z(get, set): Float;
	
	inline public function new(x: Float = 0, y: Float = 0, z: Float = 0){
		this = new Float32Array(3);
		set_x(x);
		set_y(y);
		set_z(z);
	}

	inline public function set(x: Float, y: Float, z: Float){
		set_x(x);
		set_y(y);
		set_z(z);
	}

	inline function get_x() return this[0];
	inline function set_x(v: Float) return this[0] = v;

	inline function get_y() return this[1];
	inline function set_y(v: Float) return this[1] = v;

	inline function get_z() return this[2];
	inline function set_z(v: Float) return this[2] = v;

}

@:keepSub
class UVec3 extends UniformBase<Vec3> implements IAppliable {
	public function new(gl: GLContext, name:String, index:GLUniformLocation, x:Float = 0, y:Float = 0, z:Float = 0) {
		super(gl, name, index, new Vec3(x, y, z));
	}
	public inline function apply():Void {
		gl.uniform3f(location, data.x, data.y, data.z);
		dirty = false;
	}
}