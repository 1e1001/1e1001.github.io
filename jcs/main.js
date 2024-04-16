// saddened by the presence of javascript in my compiler
/// <reference types="./types.d.ts" />
import { createInterface } from "node:readline";
import { stdin, stdout } from "node:process";
import { Worker } from "node:worker_threads";

/**
 * @template {string} T
 * @arg {T} type
 * @return {Thread<T>}
 */
function make_thread(type) {
	/** @type {null | [(v: Res<T>) => void, (v: any) => void]} */
	let callback = null;
	/** @type {Worker | null} */
	let worker = null;
	/** @type {Thread<T>} */
	const thread = {
		close: () => {
			if (!worker)
				throw new Error("internal precondition violated");
			return worker.terminate();
		},
		ready() {},
		counter: 0,
	};
	thread.run = (req, ok, err) => {
		++thread.counter;
		if (callback)
			throw new Error("thread handling two requests!");
		callback = [ok, err];
		if (!worker)
			throw new Error("internal precondition violated");
		worker.postMessage(req);
	}
	function new_worker(write) {
		const res = new Worker(new URL(`type_${type}.js`, import.meta.url));
		res.on("message", /** @arg { "ready" | Res<T> } */ res => {
			if (res !== "ready") {
				if (!callback)
					throw new Error("internal precondition violated");
				callback[0](res);
				callback = null;
			}
			thread.ready();
		});
		res.on("error", err => {
			if (callback)
				callback[1](err);
			new_worker(write);
			throw err;
		});
		write(res);
	}
	new_worker(w => worker = w);
	return thread;
}

/** @type {(() => Promise<void>)[]} */
let close_calls = [];

/**
 * @template {string} T
 * @arg {T} type
 * @arg {number} count
 * @return {(v: Req<T>) => Promise<Res<T>>}
 */
function thread_pool(type, count) {
	/** @type {Thread<T>[]} */
	const threads = [];
	/** @type {Thread<T>[]} */
	const ready = [];
	/** @type {[Req<T>, (v: Res<T>) => void, (v: any) => void][]} */
	const queue = [];
	for (let i = 0; i < count; ++i) {
		const thread = make_thread(type);
		thread.ready = () => {
			const next = queue.pop();
			if (next) {
				thread.run(...next);
			} else {
				ready.push(thread);
			}
		};
		threads.push(thread);
	}
	close_calls.push(() => {
		console.log("stats:", type, threads.map(v => v.counter));
		return Promise.all(threads.map(v => v.close));
	});
	return req => new Promise((ok, err) => {
		const thread = ready.pop();
		if (thread)
			thread.run(req, ok, err);
		queue.push([req, ok, err]);
	});
}

let active_count = 0;
/** @type {() => Promise<void>} */
let active_zero_call = () => Promise.resolve();

/** @type {{[K in Req<string>["type"]]: (r: Req<K>) => Promise<Res<K>>}} */
const types = {
	color: thread_pool("color", 2),
	css: thread_pool("css", 8),
	math: thread_pool("math", 2),
	lt: async req => {
		if (req.close) {
			rl.close();
			active_zero_call = () => Promise.all(close_calls.map(v => v())).then(() => process.exit(0));
		}
		delete req.close;
		return req;
	}
};

const rl = createInterface({ input: stdin, output: stdout });

/** @arg {string} line */
async function handle(line) {
	// debug helper
	if (line === "debug") {
		console.log(types);
		return;
	}
	if (!line.startsWith("jcs"))
		return;
	++active_count;
	/** @type Res<string> | null */
	let res = null;
	let id = -1;
	try {
		/** @type Req<string> */
		const req = JSON.parse(line.slice(3));
		id = req.id;
		res = await types[req.type](req);
	} catch (e) {
		res = { id, type: "err", text: (e.toString || (() => "<no toString impl>")).call(e) };
	}
	console.log("jcs" + JSON.stringify(res));
	if (!--active_count)
		await active_zero_call();
}

rl.on("line", line => void handle(line));
