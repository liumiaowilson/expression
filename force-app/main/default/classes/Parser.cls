public with sharing class Parser {
    private final List<Token> tokens;
    private Integer current = 0;

    public Parser(List<Token> tokens) {
        this.tokens = tokens;
    }

    public Expr parse() {
        return expression();
    }

    private Expr equality() {
        Expr expr = comparison();

        while (match(new List<TokenType>{
                TokenType.BANG_EQUAL, TokenType.EQUAL, TokenType.EQUAL_EQUAL, TokenType.LESS_GREATER, TokenType.DOUBLE_PIPE, TokenType.DOUBLE_AMPERSAND
        })) {
            Token operator = previous();
            Expr right = comparison();
            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr comparison() {
        Expr expr = term();

        while (match(
                new List<TokenType>{
                        TokenType.GREATER, TokenType.GREATER_EQUAL, TokenType.LESS, TokenType.LESS_EQUAL
                }
        )) {
            Token operator = previous();
            Expr right = term();
            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr term() {
        Expr expr = factor();

        while (match(new List<TokenType>{
                TokenType.MINUS, TokenType.PLUS, TokenType.AMPERSAND
        })) {
            Token operator = previous();
            Expr right = factor();
            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr factor() {
        Expr expr = unary();

        while (match(new List<TokenType>{
                TokenType.SLASH, TokenType.STAR, TokenType.EXPONENT
        })) {
            Token operator = previous();
            Expr right = unary();
            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr unary() {
        if (match2(TokenType.BANG, TokenType.MINUS)) {
            Token operator = previous();
            Expr right = unary();
            return new Expr.Unary(operator, right);
        }

        return primary();
    }

    private Expr primary() {
        if (match2(TokenType.NUMBER_LITERAL, TokenType.STRING_LITERAL)) {
            return new Expr.Literal(previous().literal);
        }

        if (match(TokenType.LEFT_PAREN)) {
            Expr expr = expression();
            consume(TokenType.RIGHT_PAREN, 'Expect \')\' after expression.');
            return new Expr.Grouping(expr);
        }

        throw error(peek(), 'Expect expression.');
    }

    private Expr expression() {
        return equality();
    }

    private Boolean match(TokenType type) {
        return match(new List<TokenType>{
                type
        });
    }

    private Boolean match2(TokenType type1, TokenType type2) {
        return match(new List<TokenType>{
                type1, type2
        });
    }

    private Boolean match(List<TokenType> types) {
        for (TokenType type : types) {
            if (check(type)) {
                advance();
                return true;
            }
        }

        return false;
    }

    private Boolean check(TokenType type) {
        if (isAtEnd()) {
            return false;
        }

        return peek().type == type;
    }

    private Token advance() {
        if (!isAtEnd()) {
            current++;
        }

        return previous();
    }

    private Boolean isAtEnd() {
        return peek().type == TokenType.EOF;
    }

    private Token peek() {
        return tokens.get(current);
    }

    private Token previous() {
        return tokens.get(current - 1);
    }

    private Token consume(TokenType type, String message) {
        if (check(type)) {
            return advance();
        }

        throw error(peek(), message);
    }

    private ParseException error(Token token, String message) {
        throw new ParseException(
                'Error at token ' + token.toString() + ': ' + message
        );
    }

    public class ParseException extends Exception {
    }
}