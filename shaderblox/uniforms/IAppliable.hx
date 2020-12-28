package shaderblox.uniforms;

import webgl.GLUniformLocation;

/**
 * All Uniforms are IAppliable.
 * "apply()" is used to upload updated uniform values to the GPU.
 * @author Andreas Rønning
 */

interface IAppliable 
{
	var dirty: Bool;
	var alwaysDirty: Bool;
	var location: GLUniformLocation;
	var name: String;
	function apply(): Void;
}