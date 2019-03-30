package shaderblox.uniforms;

import gluon.es2.GLUniformLocation;

/**
 * All Uniforms are IAppliable.
 * "apply()" is used to upload updated uniform values to the GPU.
 * @author Andreas Rønning
 */

interface IAppliable 
{
	var location: GLUniformLocation;
	var name: String;
	function apply(): Void;
}