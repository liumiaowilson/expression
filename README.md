# Formula Evaluator

Allows you to evaluate formulas through Apex code.

## Installation

### Deploy to Salesforce

Clone the repo and deploy the source code, or click the button below to directly deploy to Salesforce.

[![Deploy to Salesforce](assets/deploy.png)](https://githubsfdeploy.herokuapp.com/app/githubdeploy/cesarParra/formula-evaluator)

## Usage

Use `FormulaEvaluator` class to evaluate formulas.

```apex
String formula = '1 + 1';
Object result = FormulaEvaluator.evaluate(formula);
Assert.areEqual(2, result);
```

## Supported Operators and Functions

### Operators

#### Math Operators

- `+` Addition

```apex
FormulaEvaluator.evaluate('1 + 1'); // 2
```

- `-` Subtraction

```apex
FormulaEvaluator.evaluate('1 - 1'); // 0
```

- `*` Multiplication

```apex
FormulaEvaluator.evaluate('2 * 2'); // 4
```

- `/` Division

```apex
FormulaEvaluator.evaluate('4 / 2'); // 2
```

- `^` Exponentiation

```apex
FormulaEvaluator.evaluate('2 ^ 2'); // 4
```

#### Misc

- `( )` Parentheses

Groups expressions together.

```apex
FormulaEvaluator.evaluate('(1 + 1) * 2'); // 4
```

#### Logical Operators

- `=` and `==` Equal

Evaluates if two values are equal. The `=` and `==` operators are equivalent.

```apex
FormulaEvaluator.evaluate('1 = 1'); // true
```

- `<>` and `!=` Not Equal

Evaluates if two values are not equal. The `<>` and `!=` operators are equivalent.

```apex
FormulaEvaluator.evaluate('1 <> 2'); // true
```

- `<` Less Than

Evaluates if the first value is less than the second value.

```apex
FormulaEvaluator.evaluate('1 < 2'); // true
```

- `>` Greater Than

Evaluates if the first value is greater than the second value.

```apex
FormulaEvaluator.evaluate('2 > 1'); // true
```

- `<=` Less Than or Equal

Evaluates if the first value is less than or equal to the second value.

```apex
FormulaEvaluator.evaluate('1 <= 1'); // true
```

- `>=` Greater Than or Equal

Evaluates if the first value is greater than or equal to the second value.

```apex
FormulaEvaluator.evaluate('1 >= 1'); // true
```

- `&&` Logical AND

Evaluates if both values are true.

```apex
FormulaEvaluator.evaluate('true && true'); // true
```

- `||` Logical OR

Evaluates if either value is true.

```apex
FormulaEvaluator.evaluate('true || false'); // true
```

#### String Operators

- `&` and `+` Concatenation

Concatenates two strings together. The `&` and `+` operators are equivalent.

```apex
FormulaEvaluator.evaluate('"Hello" & " " & "World"'); // "Hello World"
```

### Functions

#### Logical Functions

- `AND`

Returns a TRUE response if all values are true; returns a FALSE response if one or more values are false.

Accepts multiple arguments, but must have at least 2.

```apex
FormulaEvaluator.evaluate('AND(true, true)'); // true
FormulaEvaluator.evaluate('AND(true, false, true)'); // false
```

---

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

### Setup

Create a scratch org by running:

```bash
sfdx force:org:create -f config/project-scratch-def.json -a formula-evaluator -s
```

Then push the source to the scratch org:

```bash
sfdx force:source:push
```

### Running tests

Run the tests with:

```bash
sfdx force:apex:test:run
```
