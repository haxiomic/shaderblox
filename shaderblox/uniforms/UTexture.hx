package shaderblox.uniforms;

import gluon.webgl.GLContext;
import gluon.webgl.GLContext.TextureTarget;
import gluon.webgl.GLUniformLocation;
import gluon.webgl.GLTexture;
/**
 * GLTexture uniform
 * @author Andreas Rønning
 */

@:keepSub
class UTexture extends UniformBase<GLTexture> implements IAppliable  {
	public var samplerIndex:Int;
	static var lastActiveTexture:Int = -1;
	var cube:Bool;
	public var type: TextureTarget;
	public function new(gl: GLContext, name:String, index:GLUniformLocation, cube:Bool = false) {
		this.cube = cube;
		type = cube?TEXTURE_CUBE_MAP:TEXTURE_2D;
		super(gl, name, index, NONE);
	}

	var gpuSideValue: Int = -1;
	public inline function apply():Void {
		if (data == NONE) return;

		var idx = TEXTURE0 + samplerIndex;
		if (lastActiveTexture != idx) {
			gl.activeTexture(idx);
			lastActiveTexture = idx;
		}

		gl.bindTexture(type, data);

		if (gpuSideValue != samplerIndex) {
			gl.uniform1i(location, samplerIndex);
			gpuSideValue = samplerIndex;
		}
	}
}