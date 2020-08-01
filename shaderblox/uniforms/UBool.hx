package shaderblox.uniforms;

import gluon.webgl.GLContext;
import gluon.webgl.GLUniformLocation;

/**
 * Bool uniform
 * @author Andreas Rønning
 */
@:keepSub
class UBool extends UniformBase<Bool> implements IAppliable {
	public function new(gl: GLContext, name:String, index:GLUniformLocation, f:Bool = false) {
		super(gl, name, index, f);
	}
	public inline function apply():Void {
		gl.uniform1i(location, data ? 1 : 0);
		dirty = false;
	}
}