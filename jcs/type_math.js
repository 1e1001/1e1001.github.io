import katex from "katex";
import { register } from "./worker_common.js";

register("math", async req => {
	const html = katex.renderToString(req.tex, {
		throwOnError: true,
		displayMode: req.display,
		output: "mathml",
		trust: true,
	});
	return { html };
})
