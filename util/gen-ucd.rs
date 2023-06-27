use ucd::{Codepoint, UnicodeCategory};

// const TABLE_8: &str = include!("./table-8.rs");
const TABLE_8: &str = "";

#[allow(clippy::type_complexity)]
fn run(chunk: u32) -> (Vec<(u32, u32)>, Vec<(u32, u32)>) {
	let mut aligned = Vec::new();
	let mut unaligned = Vec::new();
	let mut span_start = None;
	for i in 0u32..0xFFFF {
		if let Ok(v) = char::try_from(i) {
			let non8 = !TABLE_8.contains(v);
			if !matches!(
				v.category(),
				UnicodeCategory::Unassigned | UnicodeCategory::Surrogate | UnicodeCategory::Control
			) {
				if span_start.is_none() && non8 {
					span_start = Some(i);
				}
			} else if let Some(mut start) = span_start.take() {
				let mut end = i;
				while matches!(char::try_from(end).map(|c| TABLE_8.contains(c)), Ok(true) | Err(_)) {
					end -= 1;
				}
				let mut n_aligned = 0;
				let align_start = start;
				while end - start >= chunk {
					n_aligned += 1;
					start += chunk;
				}
				if n_aligned > 0 {
					aligned.push((align_start, n_aligned));
				}
				if start < i {
					unaligned.push((start, end - start));
				}
			}
		}
	}
	(aligned, unaligned)
}

fn print_arr(data: Vec<(u32, u32)>, name: &str) {
	fn arr(na: char, nb: &str, data: impl Iterator<Item = u32>) {
		print!("var ch{na}_{nb}=new Uint32Array([");
		for i in data {
			print!("{i},");
		}
		println!("]);");
	}
	arr('s', name, data.iter().map(|v| v.0));
	arr('l', name, data.iter().map(|v| v.1));
	println!("var chi_{name}=0;");
}

fn main() {
	let (aligned, unaligned) = run(128);
	print_arr(aligned, "blk");
	print_arr(unaligned, "edge");
}
