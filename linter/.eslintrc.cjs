const config = {
	plugins: ['zonia'],
	extends: ['plugin:zonia/react'],
	parserOptions: {
		sourceType: 'module',
		tsconfigRootDir: __dirname,
		project: './tsconfig.json',
	},
	rules: {
		'default-case-last': 'off',
		'import/no-extraneous-dependencies': 'off',
		'react/destructuring-assignment': 'off',
		'react/function-component-definition': 'off',
		'react/jsx-props-no-spreading': 'off',
		'react/require-default-props': 'off',
	},
};

module.exports = config;
