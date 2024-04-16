// cross-file typedefs
namespace globalThis {
	type Data<T, A> = {id: number, type: T} & A;

	type ReqInner =
	| Data<"color", {text: string, lang: string}>
	| Data<"css", {css: string, name: string, repeat: number}>
	| Data<"lt", {}>
	| Data<"math", {tex: string, display: boolean}>;

	type ResInner =
		| Data<"color", {html: string}>
		| Data<"css", {css: string}>
		| Data<"err", {text: string}>
		| Data<"lt", {}>
		| Data<"math", {html: string}>;

	export type Req<T extends string> = ReqInner & {type: T};
	export type Res<T extends string> = ResInner & {type: T};

	export interface Thread<T> {
		close(): Promise<number>;
		run(v: Req<T>, ok: (v: Res<T>) => void, err: (v: unknown) => void): void;
		ready(): void;
		counter: number;
	}
}
