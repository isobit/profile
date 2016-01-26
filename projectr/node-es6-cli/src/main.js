import program from 'commander';

export function main() {
	program
		.version(require('../package.json').version)
		.parse(process.argv);
}
