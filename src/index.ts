type PageObjectSubPage = [">", string];
type PageObjectExternal = ["^", string, string];
type PageObjectExternalGitHub = ["^g", string, string?];
type PageObjectScript = ["x", string, ...string[]];
type PageObjectRawText = string;
type PageObjectGroup = ["g", ...PageObject[]];

type PageObject = /*
	*/PageObjectSubPage
	| PageObjectExternal
	| PageObjectExternalGitHub
	| PageObjectScript
	| PageObjectRawText
	| PageObjectGroup;

// interface SiteFolder {
//   index: string
// }

interface SiteBlog {
	type: "blog"
	path: string
}

type Page = PageObject[] | SiteBlog | string;

interface PagesJSON {
	out: string
  pages: Record<string, Page>
}

interface TemplatesJSON {
  templates: Record<string, string[]>
}

async function GetJSON<T>(path: string) {
	return JSON.parse(await GetFile(path)) as T;
}

async function GetFile(path: string) {
	return new TextDecoder(`utf-8`).decode(await Deno.readFile(path));
}

const templates = (await GetJSON<TemplatesJSON>("./templates/templates.json")).templates;

async function GetTemplate(name: string, parts: string[], scripts: string[]) {
	enum TemplateState {
		Normal, FoundPercent, ReadingTemplate
	}
	const text = templates[name].join("");
	let out = "";
	let template = "";
	let state = TemplateState.Normal;
	for (let i = 0; i < text.length; i++) {
		const char = text[i];
		if (state === TemplateState.Normal) {
			if (char === `%`) {
				state = TemplateState.FoundPercent;
			} else {
				out += char;
			}
		} else if (state === TemplateState.FoundPercent) {
			if (char === `(`) {
				state = TemplateState.ReadingTemplate;
				template = "";
			} else {
				state = TemplateState.Normal;
				out += `%${char}`;
			}
		} else if (state === TemplateState.ReadingTemplate) {
			if (char === `)`) {
				state = TemplateState.Normal;
				const int = parseInt(template);
				if (isNaN(int)) {
					if (template.startsWith(`//`)) {
						scripts.push(await GetTemplate(template.slice(2), [], scripts));
					} else {
						out += await GetFile(`./templates/${template}`);
					}
				} else {
					out += parts[int];
				}
			} else {
				template += char;
			}
		}
	}
	return out;
}

async function ParseObjectList(objects: PageObject[], name: string, scripts: string[]) {
	let out: string[] = [];
	for (const element of objects) {
		if (typeof element === `string`) {
			out.push(await GetTemplate(`_raw`, [element.replace(/ /g, `&nbsp;`)], scripts));
		} else {
			if (element[0] === `>`) {
				out.push(await GetTemplate(`>`, [`${name}/${element[1]}.html`, element[1].replace(/ /g, `&nbsp;`)], scripts));
			} else if (element[0] === `^`) {
				out.push(await GetTemplate(`^`, [element[2], element[1].replace(/ /g, `&nbsp;`)], scripts));
			} else if (element[0] === `^g`) {
				out.push(await GetTemplate(`^`, [element[1], element[1].replace(/ /g, `&nbsp;`)], scripts));
			} else if (element[0] === `g`) {
				out.push(await GetTemplate(`_raw`, [(await ParseObjectList(element.slice(1), name, scripts)).join("")], scripts));
			} else if (element[0] === `x`) {
				out.push(await GetTemplate(`x_${element[1]}`, element.slice(2), scripts));
			}
		}
	}
	return out;
}

async function MakePage(name: string, page: Page): Promise<[string, string][]> {
	const path = `${name}.html`;
	if (typeof page === `string`) return [[path, await GetFile(page)]];
	if (`path` in page) {
		if (`type` in page) {
			if (page.type === `blog`) {
				// blog shit
				return [[path, `no blog get real`]]
			}
			return [[path, `error`]];
		}
	}
	// if (`index` in page) {
	// 	// folder
	// 	await Deno.mkdir(`${pages.out}/${name.slice(pages.slice.length)}`);
	//  return
	// }
	// page
	const scripts: string[] = [];
	const html = await ParseObjectList(page, name, scripts);
	const maxPageLength = name === `home` ? 6 : 5;
	const maxPageSize = 5;
	if (html.length > maxPageLength) {
		// scroll that shit
		const pageCount = html.length - maxPageSize + 1;
		const pages: [string, string][] = [];
		for (let i = 0; i < pageCount; i++) {
			const content = html.slice(i, i + maxPageLength);
			// add page title
			const elements: string[] = [];
			if (name !== `home`) {
				let parent = name.split(`/`).slice(0, -1).join(`/`);
				if (parent === `home`) parent = `index`;
				elements.push(await GetTemplate(`_back`, [`${parent}.html`], scripts));
			}
			if (i < pageCount - 1) elements.push(await GetTemplate(`_scroll_down`, [`${name}-${i+1}.html`], scripts));
			else elements.push(await GetTemplate(`_scroll_down_none`, [], scripts));
			if (i > 0) {
				if (i > 1) elements.push(await GetTemplate(`_scroll_up`, [`${name}-${i-1}.html`], scripts));
				else elements.push(await GetTemplate(`_scroll_up`, [path], scripts));
			} else elements.push(await GetTemplate(`_scroll_up_none`, [], scripts));
			elements.push(await GetTemplate(`_full_page`, [`${name}-full.html`], scripts));
			if (elements.length > 0) content.unshift(await GetTemplate(`_topbar`, [elements.join("")], scripts));
			content.unshift(await GetTemplate(`_title`, [name], scripts));
			const scriptsHTML = scripts.join(`\n`);
			const contentHTML = await GetTemplate(`page`, [name, content.join(`<br>`), scriptsHTML], scripts);
			if (i > 0) pages.push([`${name}-${i}.html`, contentHTML]);
			else pages.push([path, contentHTML]);
		}
		// also add the full version
		while (html.length < maxPageLength) html.push(await GetTemplate(`_empty`, [], scripts));
		const elements: string[] = [];
		if (name !== `home`) {
			let parent = name.split(`/`).slice(0, -1).join(`/`);
			if (parent === `home`) parent = `index`;
			elements.push(await GetTemplate(`_back`, [`${parent}.html`], scripts));
		}
		if (elements.length > 0) html.unshift(await GetTemplate(`_topbar`, [elements.join("")], scripts));
		html.unshift(await GetTemplate(`_title`, [name], scripts));
		const scriptsHTML = scripts.join(`\n`);
		const contentHTML = await GetTemplate(`page`, [name, html.join(`<br>`), scriptsHTML], scripts);
		pages.push([`${name}-full.html`, contentHTML]);
		return pages;
	} else {
		// add the standard shit
		while (html.length < maxPageLength) html.push(await GetTemplate(`_empty`, [], scripts));
		const elements: string[] = [];
		if (name !== `home`) {
			let parent = name.split(`/`).slice(0, -1).join(`/`);
			if (parent === `home`) parent = `index`;
			elements.push(await GetTemplate(`_back`, [`${parent}.html`], scripts));
		}
		if (elements.length > 0) html.unshift(await GetTemplate(`_topbar`, [elements.join("")], scripts));
		html.unshift(await GetTemplate(`_title`, [name], scripts));
		const scriptsHTML = scripts.join(`\n`);
		const contentHTML = await GetTemplate(`page`, [name, html.join(`<br>`), scriptsHTML], scripts);
		return [[path, contentHTML]];
	}
}

const pages = await GetJSON<PagesJSON>(`./pages.json`);
for (const page of Object.entries(pages.pages)) {
	const entries = await MakePage(page[0], page[1]);
	for (const page of entries) {
		let path;
		if (page[0] === `home.html`) {
			path = pages.out + `index.html`;
		} else {
			const relative = page[0];
			const split = relative.split(`/`);
			if (split.length > 1) await Deno.mkdir(pages.out + split.slice(0, -1).join(`/`), {recursive: true});
			path = pages.out + relative;
		}
		console.log(path);
		await Deno.writeFile(path, new TextEncoder().encode(page[1]));
	}
}
