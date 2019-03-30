package shaderblox.uniforms;

import gluon.es2.GLContext;
import gluon.es2.GLUniformLocation;

/**
 * Int uniform
 * @author Andreas Rønning
 */
 
@:keepSub
class UInt extends UniformBase<Int> implements IAppliable  {
	public function new(gl: GLContext, name:String, index:GLUniformLocation, f:Int = 0) {
		super(gl, name, index, f);
	}
	public inline function apply():Void {
		gl.uniform1i(location, data);
		dirty = false;
	}
}