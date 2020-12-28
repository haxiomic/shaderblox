package shaderblox.uniforms;

import webgl.GLContext;
import webgl.GLUniformLocation;

/**
 * Matrix3D uniform (not transposed)
 * @author Andreas Rønning
 */

@:keepSub
class UMatrix extends UniformBase<Matrix3D> implements IAppliable {
	public function new(gl: GLContext, name:String, index:GLUniformLocation, ?m:Matrix3D) {
		if (m == null) m = new Matrix3D();
		super(gl, name, index, m);
	}
	public inline function apply():Void {
		#if lime
		gl.uniformMatrix3D(location, false, data);
		dirty = false;
		#elseif snow
		if (location != -1) {
			gl.uniformMatrix4fv(location, false, new Float32Array(data.rawData));
			dirty = false;
		}
		#end
	}
}