import browserslist from "browserslist";
import { browserslistToTargets, transform } from "lightningcss";
import { register } from "./worker_common.js";

const targets = browserslistToTargets(browserslist(">= 0.25% and not dead"));

register("css", async req => {
	const filename = req.name;
	let code = Buffer.from(req.css);
	for (let i = 0; i < req.repeat; ++i) {
		code = transform({
			filename,
			code,
			minify: true,
			targets
		}).code;
	}
	return { css: new TextDecoder().decode(code) };
});
