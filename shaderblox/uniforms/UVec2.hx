package shaderblox.uniforms;

import typedarray.Float32Array;
import gluon.webgl.GLContext;
import gluon.webgl.GLUniformLocation;

abstract Vec2(Float32Array) to Float32Array from Float32Array {

	public var x(get, set): Float;
	public var y(get, set): Float;
	
	inline public function new(x: Float = 0, y: Float = 0){
		this = new Float32Array(2);
		set_x(x);
		set_y(y);
	}

	inline public function set(x: Float, y: Float){
		set_x(x);
		set_y(y);
	}

	inline function get_x() return this[0];
	inline function set_x(v: Float) return this[0] = v;

	inline function get_y() return this[1];
	inline function set_y(v: Float) return this[1] = v;

}

/**
 * Vector2 float uniform
 * @author Andreas Rønning
 */

@:keepSub
class UVec2 extends UniformBase<Vec2> implements IAppliable  {

	public function new(gl: GLContext, name:String, index:GLUniformLocation, x:Float = 0, y:Float = 0) {
		super(gl, name, index, new Vec2(x, y));
	}

	public inline function apply():Void {
		gl.uniform2f(location, data.x, data.y);
		dirty = false;
	}

}