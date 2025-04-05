const config = {
	files: ['.'],
	formats: [
		{
			name: 'junit',
			output: 'file',
			path: 'lint-warnings.xml',
			id: 'lintIssues',
		},
	],
};
module.exports = config;
