public with sharing class Scanner {
    private final String source;
    private final List<Token> tokens = new List<Token>();
    private Integer start = 0;
    private Integer current = 0;

    public Scanner(String source) {
        this.source = source;
    }

    public List<Token> scanTokens() {
        while (!isAtEnd()) {
            start = current;
            scanToken();
        }

        tokens.add(new Token(TokenType.EOF, '', null));
        return tokens;
    }

    private void scanToken() {
        String character = advance();

        switch on character {
            // Single characters
            when '+' {
                addToken(TokenType.PLUS);
            }
            when '-' {
                addToken(TokenType.MINUS);
            }
            when '*' {
                addToken(TokenType.STAR);
            }
            when '/' {
                addToken(TokenType.SLASH);
            }
            when '^' {
                addToken(TokenType.EXPONENT);
            }
            when '(' {
                addToken(TokenType.LEFT_PAREN);
            }
            when ')' {
                addToken(TokenType.RIGHT_PAREN);
            }
            when ',' {
                addToken(TokenType.COMMA);
            }

            // One or more character tokens
            when '=' {
                addToken(match('=') ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
            }
            when '<' {
                String next = peek();
                if (next == '=') {
                    advance();
                    addToken(TokenType.LESS_EQUAL);
                } else if (next == '>') {
                    advance();
                    addToken(TokenType.LESS_GREATER);
                } else {
                    addToken(TokenType.LESS);
                }
            }
            when '!' {
                addToken(match('=') ? TokenType.BANG_EQUAL : TokenType.BANG);
            }
            when '>' {
                addToken(match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
            }
            when '&' {
                addToken(match('&') ? TokenType.DOUBLE_AMPERSAND : TokenType.AMPERSAND);
            }
            when '|' {
                String next = peek();
                if (next == '|') {
                    advance();
                    addToken(TokenType.DOUBLE_PIPE);
                } else {
                    throw new ScannerException('Unexpected character' + next + ' Expected another | for an OR operator');
                }
            }

            when ' ', '\r', '\t', '\n' {
                // Ignore whitespace
            }

            when '"' {
                stringLiteral();
            }

            when else {
                if (isDigit(character)) {
                    numberLiteral();
                } else {
                    throw new ScannerException('Unexpected character: ' + character);
                }
            }
        }
    }

    private String advance() {
        current++;
        return source.substring(current - 1, current);
    }

    private void addToken(TokenType type) {
        addToken(type, null);
    }

    private void addToken(TokenType type, Object literal) {
        String text = source.substring(start, current);
        tokens.add(new Token(type, text, literal));
    }

    private Boolean match(String expected) {
        if (isAtEnd()) return false;
        if (!source.substring(current, current + 1).equals(expected)) return false;

        current++;
        return true;
    }

    private String peek() {
        if (isAtEnd()) return '';
        return source.substring(current, current + 1);
    }

    private String peekNext() {
        if (current + 1 >= source.length()) return '';
        return source.substring(current + 1, current + 2);
    }

    private void stringLiteral() {
        while (peek() != '"' && !isAtEnd()) {
            advance();
        }

        if (isAtEnd()) {
            throw new ScannerException('Unterminated string');
        }

        // The closing "
        advance();

        // Trim the surrounding quotes
        String value = source.substring(start + 1, current - 1);
        addToken(TokenType.STRING_LITERAL, value);
    }

    private Boolean isDigit(String character) {
        return character >= '0' && character <= '9';
    }

    private void numberLiteral() {
        while (isDigit(peek())) {
            advance();
        }

        // Look for a fractional part
        if (peek() == '.' && isDigit(peekNext())) {
            // Consume the "."
            advance();

            while (isDigit(peek())) {
                advance();
            }
        }

        addToken(TokenType.NUMBER_LITERAL, Decimal.valueOf(source.substring(start, current)));

    }

    private Boolean isAtEnd() {
        return current >= source.length();
    }

    public class ScannerException extends Exception {}
}