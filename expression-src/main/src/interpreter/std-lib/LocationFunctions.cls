public with sharing class LocationFunctions {
    public static final Map<String, ExpressionFunction> FUNCTIONS = new Map<String, ExpressionFunction>{
        'LOCATION' => new LocationFn(),
        'DISTANCE' => new DistanceFn()
    };

    private class LocationFn extends ExpressionFunction {
        public override Object call(List<Expr> arguments) {
            // Argument must be a Decimal
            Object latitude = evaluate(arguments.get(0));
            if (!(latitude instanceof Decimal)) {
                throw new FunctionExecutionException(
                    'Error executing "LOCATION" function: the argument must evaluate to a DECIMAL.'
                );
            }

            // Argument must be a Decimal
            Object longitude = evaluate(arguments.get(1));
            if (!(longitude instanceof Decimal)) {
                throw new FunctionExecutionException(
                    'Error executing "LOCATION" function: the argument must evaluate to a DECIMAL.'
                );
            }

            return Location.newInstance((Decimal)latitude, (Decimal)longitude);
        }

        public override Arity getArity() {
            return Arity.exactly(2);
        }
    }

    private class DistanceFn extends ExpressionFunction {
        public override Object call(List<Expr> arguments) {
            // First object must be a System.Location
            Object first = evaluate(arguments.get(0));
            if (!(first instanceof System.Location)) {
                throw new FunctionExecutionException(
                    'Error executing "DISTANCE" function: the first argument must evaluate to a LOCATION.'
                );
            }

            // Second object must be a System.Location
            Object second = evaluate(arguments.get(1));
            if (!(second instanceof System.Location)) {
                throw new FunctionExecutionException(
                    'Error executing "DISTANCE" function: the second argument must evaluate to a LOCATION.'
                );
            }

            // Third argument must be a string
            Object third = evaluate(arguments.get(2));
            if (!(third instanceof String)) {
                throw new FunctionExecutionException(
                    'Error executing "DISTANCE" function: the third argument must evaluate to a STRING.'
                );
            }

            // The third argument must either be "km" or "mi"
            String unit = (String)third;
            if (!unit.equals('km') && !unit.equals('mi')) {
                throw new FunctionExecutionException(
                    'Error executing "DISTANCE" function: the third argument must be either "km" or "mi".'
                );
            }

            return Location.getDistance((System.Location)first, (System.Location)second, unit);
        }

        public override Arity getArity() {
            return Arity.exactly(3);
        }
    }
}
