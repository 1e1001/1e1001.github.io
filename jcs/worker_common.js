import { parentPort } from "node:worker_threads";

let thread_initialized = false;

/**
 * @template {string} T
 * @arg {T} type
 * @arg {(v: Req<T>) => Promise<Res<T> & {id: unknown, type: unknown}>} call
 */
export function register(type, call) {
	if (thread_initialized)
		throw new Error("register cannot be called more than once");
	thread_initialized = true;
	/**
	 * @arg {Req<T>} req
	 * @return {Promise<Res<T>>}
	 */
	async function handle_req(req) {
		if (req.type !== type)
			throw new Error("internal precondition violated");
		const res = await call(req);
		res.type = type;
		res.id = req.id;
		return /** @type {Res<T>} */ (res);
	}
	parentPort.on("message", /** @arg {Req<T>} req */ async req => parentPort.postMessage(await handle_req(req)));
	parentPort.postMessage("ready");
}
