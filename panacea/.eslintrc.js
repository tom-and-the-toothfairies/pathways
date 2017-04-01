module.exports = {
  "env": {
    "browser": true,
    "es6": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "sourceType": "module",
    "ecmaVersion": 2017
  },
  "rules": {
    "indent": [
      "error",
      2
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "quotes": [
      "error",
      "single"
    ],
    "semi": [
      "error",
      "always"
    ],
    "no-multi-spaces": [
      "error",
      {
        "exceptions": {
          "VariableDeclarator": true
        }
      }
    ],
    "eqeqeq": "error",
    "no-useless-concat": "error",
    "require-await": "error",
    "array-bracket-spacing": "error",
    "brace-style": "error",
    "eol-last": "error",
    "func-call-spacing": "error",
    "key-spacing": "error",
    "keyword-spacing": "error",
    "no-lonely-if": "error",
    "no-multiple-empty-lines": "error",
    "no-trailing-spaces": "error",
    "semi-spacing": "error",
    "space-in-parens": "error",
    "space-infix-ops": "error",
    "space-unary-ops": "error",
    "arrow-spacing": "error",
    "no-duplicate-imports": "error",
    "no-var": "error",
    "object-shorthand": "error",
    "prefer-const": "error",
    "prefer-numeric-literals": "error",
    "prefer-rest-params": "error",
    "prefer-spread": "error",
    "prefer-template": "error",
    "template-curly-spacing": "error"
  }
};
