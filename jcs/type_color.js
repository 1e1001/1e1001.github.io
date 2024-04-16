import { getHighlighter } from "shiki";
import { register } from "./worker_common.js";
import { transformerBracketPairColor } from "./brackets.js";

import theme_dark from "./data/edark.json" assert {type: "json"};
import lang_racket from "./data/racket.tmLanguage.json" assert {type: "json"};

const highlighter = await getHighlighter({
	themes: [theme_dark, "light-plus"],
	langs: [lang_racket],
});

const transformers = [
	transformerBracketPairColor({
		light: [ "#0431fa", "#319331", "#7b3814" ],
		dark: [ 1, 2, 3 ].map(v => theme_dark.colors["editorBracketHighlight.foreground" + v]),
		base: "color:#000000;--shiki-dark:#FFFFFF"
	}),
];

register("color", async req => {
	if (!highlighter.getLoadedLanguages().includes(req.lang))
		await highlighter.loadLanguage(req.lang);
	const html = highlighter.codeToHtml(req.text, {
		lang: req.lang,
		themes: {
			light: "light-plus",
			dark: "edark",
		},
		transformers,
	});
	return { html };
});
