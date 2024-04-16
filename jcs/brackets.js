// heavily modified from https://gist.github.com/hunghg255/0fa614ffb8dd0107d39d90a4f131c810
// unlicensed but hopefully i've modified it enough to be ok

function bracket_color(colors, depth) {
	function inner(theme, depth) {
		return theme[depth % theme.length];
	}
	return "color:" + inner(colors.light, depth) + ";--shiki-dark:" + inner(colors.dark, depth);
}

export function transformerBracketPairColor(colors) {
  let depth = 0;

  return {
    name: "bracket-pair-color",
		tokens(lines) {
			for (let i = 0; i < lines.length; ++i) {
				const line = lines[i];
				const new_line = [];
				for (let j = 0; j < line.length; ++j) {
					const cluster = line[j];
					if (cluster.htmlStyle !== colors.base) {
						new_line.push(cluster);
						continue;
					}
					const tokens = cluster.content.split(/([\(\)\[\]\{\}])/g);
					let offset = cluster.offset;
					for (let k = 0; k < tokens.length; ++k) {
						const token = tokens[k];
						if (token.length === 0)
							continue;
						let style = cluster.htmlStyle;
						if ("([{".includes(token)) {
							style = bracket_color(colors, depth++);
						} else if (")]}".includes(token)) {
							style = bracket_color(colors, --depth);
						}
						new_line.push({
							content: token,
							explanations: cluster.explanations,
							offset,
							htmlStyle: style,
						});
						offset += token.length;
					}
				}
				lines[i] = new_line;
			}
		},
  };
};
