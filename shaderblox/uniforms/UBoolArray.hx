package shaderblox.uniforms;

import typedarray.Int32Array;
import webgl.GLContext;
import webgl.GLUniformLocation;

/**
 * Bool uniform
 * @author Andreas Rønning
 */
@:keepSub
class UBoolArray extends UniformBase<Array<Bool>> implements IAppliable {

	var buffer: Int32Array;
	var arraySize: Int;

	public function new(gl: GLContext, name:String, index:GLUniformLocation, arraySize: Int, ?f:Array<Bool>) {
		if (f == null) f = [];
		
		super(gl, name, index, f);
		this.arraySize = arraySize;
		buffer = new typedarray.Int32Array(arraySize);
	}

	public inline function apply():Void {
		// convert bools to ints for upload
		for (i in 0...arraySize) {
			buffer[i] = data[i] ? 1 : 0;
		}
		gl.uniform1iv(location, buffer);
		dirty = false;
	}
}