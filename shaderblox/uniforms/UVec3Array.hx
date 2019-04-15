package shaderblox.uniforms;

import typedarray.Float32Array;
import gluon.es2.GLContext;
import gluon.es2.GLUniformLocation;

@:keepSub
class UVec3Array extends UniformBase<Float32Array> implements IAppliable  {

	var buffer: Float32Array;
	var arraySize: Int;

	public function new(gl: GLContext, name:String, index:GLUniformLocation, arraySize: Int, ?a: Float32Array) {
		this.arraySize = arraySize;

		if (a == null) {
			buffer = new Float32Array(arraySize *  3);
		}

		super(gl, name, index, buffer);
	}

	public inline function apply():Void {
		gl.uniform3fv(location, data);
		dirty = false;
	}

}