
var canvas = document.createElement("canvas").getContext("2d");
canvas.font = "400 16px Iosevka Fuck Web";
function text_size(text) {
	return canvas.measureText(text).width;
}var lst = Array.from(document.getElementsByClassName("cens"));
for (var i = 0; i < lst.length; ++i) {
	var e = lst[i];
	e.style.display = "inline-block";
	e.style.height = "1.25em"
	e.style.marginBottom = "-0.3125em";
	e.style.width = canvas.measureText(e.innerText).width + "px";
	e.style.overflow = "hidden";
	e.className = "cens-js";
	lst[i] = [e, e.innerText];
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
		var ch = Array.from(lst[i][1]);
		for (var j = 0; j < ch.length; ++j) {
			var l = table[text_size(ch[j])] || ch[j];
			ch[j] = l[Math.floor(Math.random() * l.length)];
		}
		lst[i][0].innerText = ch.join("");
	}
}
frame();