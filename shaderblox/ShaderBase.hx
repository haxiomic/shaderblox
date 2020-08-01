package shaderblox;

import gluon.webgl.GLContext;
import gluon.webgl.GLUniformLocation;
import gluon.webgl.GLShader;
import gluon.webgl.GLProgram;

import shaderblox.attributes.Attribute;
import shaderblox.uniforms.IAppliable;
import shaderblox.uniforms.UTexture;

/**
 * Base shader type. Extend this to define new shader objects.
 * Subclasses of ShaderBase must define shader source metadata. 
 * See example/SimpleShader.hx.
 * @author Andreas Rønning
 */

@:autoBuild(shaderblox.macro.ShaderBuilder.build()) 
class ShaderBase
{
	var gl: GLContext;

	//variables prepended with _ to avoid collisions with glsl variable names
	var _uniforms:Array<IAppliable> = [];
	var _attributes:Array<Attribute> = [];
	var _textures:Array<UTexture> = [];

	public var _prog(default, null):GLProgram;
	public var _active(default, null):Bool;
	var _name:String;
	var _vert:GLShader;
	var _frag:GLShader;
	var _ready:Bool;
	var _numTextures:Int;
	var _aStride:Int = 0;

	public var _vertSource(default, null):String;
	public var _fragSource(default, null):String;

	public function new(gl: GLContext) {
		this.gl = gl;
		_name = ("" + Type.getClass(this)).split(".").pop();
		initSources();
		createProperties();
	}
	
	private function initSources():Void {}

	private function createProperties():Void {}
	
	public function create():Void{
		compile(_vertSource, _fragSource);
		_ready = true;
	}
	
	public function destroy():Void {
		gl.deleteShader(_vert);
		gl.deleteShader(_frag);
		gl.deleteProgram(_prog);
		_prog = NONE;
		_vert = NONE;
		_frag = NONE;
		_ready = false;
	}
	
	function compile(vertSource:String, fragSource:String) {
		var vertexShader = gl.createShader (VERTEX_SHADER);
		gl.shaderSource (vertexShader, vertSource);
		gl.compileShader (vertexShader);

		if (!gl.getShaderParameter (vertexShader, COMPILE_STATUS)) {
			trace("Error compiling vertex shader: " + gl.getShaderInfoLog(vertexShader));
			trace("\n"+vertSource);
			throw "Error compiling vertex shader";
		}

		var fragmentShader = gl.createShader (FRAGMENT_SHADER);
		gl.shaderSource (fragmentShader, fragSource);
		gl.compileShader (fragmentShader);
		
		if (!gl.getShaderParameter (fragmentShader, COMPILE_STATUS)) {
			trace("Error compiling fragment shader: " + gl.getShaderInfoLog(fragmentShader)+"\n");
			var lines = fragSource.split("\n");
			var i = 0;
			for (l in lines) {
				trace((i++) + " - " + l);
			}
			throw "Error compiling fragment shader";
		}
		
		var shaderProgram = gl.createProgram ();

		gl.attachShader (shaderProgram, vertexShader);
		gl.attachShader (shaderProgram, fragmentShader);
		gl.linkProgram (shaderProgram);
		
		if (!gl.getProgramParameter (shaderProgram, LINK_STATUS)) {
			throw "Unable to initialize the shader program.\n"+gl.getProgramInfoLog(shaderProgram);
		}
		
		var numUniforms = gl.getProgramParameter(shaderProgram, ACTIVE_UNIFORMS);
		var uniformLocations:Map<String,GLUniformLocation> = new Map<String, GLUniformLocation>();
		while (numUniforms-->0) {
			var uInfo = gl.getActiveUniform(shaderProgram, numUniforms);
			var loc = gl.getUniformLocation(shaderProgram, uInfo.name);
			uniformLocations[uInfo.name] = loc;
		}
		var numAttributes = gl.getProgramParameter(shaderProgram, ACTIVE_ATTRIBUTES);
		var attributeLocations:Map<String,Int> = new Map<String, Int>();
		while (numAttributes-->0) {
			var aInfo = gl.getActiveAttrib(shaderProgram, numAttributes);
			var loc:Int = cast gl.getAttribLocation(shaderProgram, aInfo.name);
			attributeLocations[aInfo.name] = loc;
		}
		
		_vert = vertexShader;
		_frag = fragmentShader;
		_prog = shaderProgram;
		
		//Validate uniform locations
		var count = _uniforms.length;
		var removeList:Array<IAppliable> = [];
		_numTextures = 0;
		_textures = [];
		for (u in _uniforms) {
			var loc = uniformLocations.get(u.name);
			if (loc == null) {
				loc = uniformLocations.get(u.name + '[0]');
			}
			if (Std.is(u, UTexture)) {
				var t:UTexture = cast u;
				t.samplerIndex = _numTextures++;
				_textures[t.samplerIndex] = t;
			}
			if (loc != null) {				
				u.location = loc;
				#if (debug && !display) trace("Defined uniform "+u.name+" at "+u.location); #end
			}else {
				removeList.push(u);
				#if (debug && !display) trace("WARNING(" + _name + "): unused uniform '" + u.name +"'"); #end
			}
		}
		while (removeList.length > 0) {
			var remove = removeList.pop();
			_uniforms.remove(remove);
		}
		//TODO: Graceful handling of unused sampler uniforms.
		/**
		 * 1. Find every sampler/samplerCube uniform
		 * 2. For each sampler, assign a sampler index from 0 and up
		 * 3. Go through uniform locations, remove inactive samplers
		 * 4. Pack remaining _active sampler
		 */
		
		//Validate attribute locations
		for (a in _attributes) {
			var loc = attributeLocations.get(a.name);
			a.location = loc == null? -1:loc;
			#if (debug && !display) if (a.location == -1) trace("WARNING(" + _name + "): unused attribute '" + a.name +"'"); #end
			#if (debug && !display) trace("Defined attribute "+a.name+" at "+a.location); #end
		}
	}
	
	public inline function activate(initUniforms:Bool = true, initAttribs:Bool = false):Void {
		if (_active) {
			if (initUniforms) setUniforms();
			if (initAttribs) setAttributes();
			return;
		}
		if (!_ready) create();
		gl.useProgram(_prog);
		if (initUniforms) setUniforms();
		if (initAttribs) setAttributes();
		_active = true;
	}
	
	public function deactivate():Void {
		if (!_active) return;
		_active = false;
		disableAttributes();
		// gl.useProgram(null);, seems to be fairly slow and we can get away without it
	}
	
	public inline function setUniforms() {
		for (u in _uniforms) {
			if (u.dirty || u.alwaysDirty) {
				u.apply();
			}
		}
	}
	public inline function setAttributes() {
		var offset:Int = 0;
		for (i in 0..._attributes.length) {
			var att = _attributes[i];
			var location = att.location;
			if (location != -1) {
				gl.enableVertexAttribArray(location);
				gl.vertexAttribPointer(location, att.itemCount, att.type, false, _aStride, offset);
			}
			offset += att.byteSize;
		}
	}
	function disableAttributes() {
		for (i in 0..._attributes.length) {
			var idx = _attributes[i].location;
			if (idx == -1) continue;
			gl.disableVertexAttribArray(idx);
		}
	}

	public function toString():String {
		return "[Shader(" + _name+", attributes:" + _attributes.length + ", uniforms:" + _uniforms.length + ")]";
	}
}