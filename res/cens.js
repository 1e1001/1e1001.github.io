var lst = Array.from(document.getElementsByClassName("cens"));
for (var i = 0; i < lst.length; ++i) {
	var e = lst[i];
	e.className = "";
}
var canvas = document.createElement("canvas").getContext("2d");
canvas.font = "400 16px Iosevka Fuck Web";
function text_size(text) {
	var m = canvas.measureText(text + "|");
	return [
		m.actualBoundingBoxLeft.toFixed(3),
		m.actualBoundingBoxRight.toFixed(3),
		m.actualBoundingBoxAscent.toFixed(3),
		m.actualBoundingBoxDescent.toFixed(3),
	].join();
}
var table = {};
var pr_i = -4096;
var c = 0;
function frame() {
	requestAnimationFrame(frame);
	if (c++ < 0)
		return;
	if (pr_i < 65536) {
		pr_i += 256;
		if (pr_i > 0) {
			for (var i = pr_i - 256; i < pr_i; ++i) {
				var c = String.fromCharCode(i);
				var n = text_size(c);
				table[n] = (table[n] || "") + c;
			}
		}
	}
	c = 0;
	for (var i = 0; i < lst.length; ++i) {
		var ch = Array.from(lst[i].innerText);
		for (var j = 0; j < ch.length; ++j) {
			var l = table[text_size(ch[j])] || ch[j];
			ch[j] = l[Math.floor(Math.random() * l.length)];
		}
		lst[i].innerText = ch.join("");
	}
}
frame();