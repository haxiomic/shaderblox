package shaderblox.uniforms;

import gluon.webgl.GLContext;
import gluon.webgl.GLUniformLocation;

/**
 * Transposed Matrix3D uniform
 * @author Andreas Rønning
 */

@:keepSub
class UMatrixTransposed extends UniformBase<Matrix3D> implements IAppliable {
	public function new(gl: GLContext, index:GLUniformLocation, ?m:Matrix3D) {
		if (m == null) m = new Matrix3D();
		super(gl, index, m);
	}
	public inline function apply():Void {
		gl.uniformMatrix3D(location, true, data);
		dirty = false;
	}
}