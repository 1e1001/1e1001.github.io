var g = {};

var currentAngle = 0;

/** @param {WebGLTexture} */
var spiritTexture;

function init() {
  /** @type {WebGL2RenderingContext} */
  var gl = initWebGL(`pfp-canvas`);
  if (!gl) {
    return;
  }

  g.program = simpleSetup(gl, `vshader`, `fshader`, [`vNormal`, `vColor`, `vPosition`], [0, 0, 0, 1], 10000);

  gl.uniform3f(gl.getUniformLocation(g.program, `lightDir`), 0, 0, 1);
  gl.uniform1i(gl.getUniformLocation(g.program, `sampler2d`), 0);

  g.box = makeBox(gl);

  spiritTexture = loadImageTexture(gl, `./assets/pfp-layers/source.png`);

  g.mvMatrix = new J3DIMatrix4();
  g.u_normalMatrixLoc = gl.getUniformLocation(g.program, `u_normalMatrix`);
  g.normalMatrix = new J3DIMatrix4();
  g.u_modelViewProjMatrixLoc = gl.getUniformLocation(g.program, `u_modelViewProjMatrix`);
  g.mvpMatrix = new J3DIMatrix4();

  gl.enableVertexAttribArray(0);
  gl.enableVertexAttribArray(1);
  gl.enableVertexAttribArray(2);

  gl.bindBuffer(gl.ARRAY_BUFFER, g.box.vertexObject);
  gl.vertexAttribPointer(2, 3, gl.FLOAT, false, 0, 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, g.box.normalObject);
  gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, g.box.texCoordObject);
  gl.vertexAttribPointer(1, 2, gl.FLOAT, false, 0, 0);

  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, g.box.indexObject);

  return gl;
}

/**
 * @param {WebGL2RenderingContext} gl
 */
function reshape(gl) {
  var canvas = document.getElementById(`pfp-canvas`);
  if (canvas.clientWidth == canvas.width && canvas.clientHeight == canvas.height) return;
  canvas.width = canvas.clientWidth;
  canvas.height = canvas.clientHeight;
  gl.viewport(0, 0, canvas.clientWidth, canvas.clientHeight);
  g.perspectiveMatrix = new J3DIMatrix4();
  g.perspectiveMatrix.lookat(0, 0, 7, 0, 0, 0, 0, 1, 0);
  g.perspectiveMatrix.perspective(30, canvas.clientWidth / canvas.clientHeight, 0.1, 10000);
}

/**
 * @param {WebGL2RenderingContext} gl
 */
function draw(gl) {
  reshape(gl);
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

  g.mvMatrix.makeIdentity();
  g.mvMatrix.rotate(20, 1, 0, 0);
  g.mvMatrix.rotate(currentAngle, 0, 1, 0);

  g.normalMatrix.load(g.mvMatrix);
  g.normalMatrix.invert();
  g.normalMatrix.transpose();
  g.normalMatrix.setUniform(gl, g.u_normalMatrixLoc, false);

  g.mvpMatrix.load(g.perspectiveMatrix);
  g.mvpMatrix.multiply(g.mvMatrix);
  g.mvpMatrix.setUniform(gl, g.u_modelViewProjMatrixLoc, false);

  gl.bindTexture(gl.TEXTURE_2D, spiritTexture);

  gl.drawElements(gl.TRIANGLES, g.box.numIndices, gl.UNSIGNED_BYTE, 0);

  currentAngle += 1;
  while (currentAngle > 360) currentAngle -= 360;

}

var gl = init();
console.log(spiritTexture);
function frame() {
  draw(gl);
  requestAnimationFrame(frame);
}
requestAnimationFrame(frame);
