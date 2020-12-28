package shaderblox.uniforms;

import webgl.GLContext;
import webgl.GLUniformLocation;

/**
 * Float uniform
 * @author Andreas Rønning
 */
 
@:keepSub
class UFloat extends UniformBase<Float> implements IAppliable  {
	public function new(gl: GLContext, name:String, index:GLUniformLocation, f:Float = 0.0) {
		super(gl, name, index, f);
	}
	public inline function apply():Void {
		gl.uniform1f(location, data);
		dirty = false;
	}
}