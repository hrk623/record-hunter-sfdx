@isTest
public class Test_Lexer {
    static testMethod void tokenize_empty() {
        List<Lexer.Token> tokens = Lexer.tokenize('');
        System.assertEquals(0, tokens.size());
    }
    static testMethod void tokenize_ZERO() {
        List<Lexer.Token> tokens = Lexer.tokenize('0');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.ZERO, tokens[0].kind);
        System.assertEquals('0', tokens[0].lexeme);
    }
    static testMethod void tokenize_NUM() {
        List<Lexer.Token> tokens = Lexer.tokenize('1');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.NUM, tokens[0].kind);
        System.assertEquals('1', tokens[0].lexeme);
    }
    static testMethod void tokenize_NUM_Large() {
        List<Lexer.Token> tokens = Lexer.tokenize('123456789');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.NUM, tokens[0].kind);
        System.assertEquals('123456789', tokens[0].lexeme);
    }
    static testMethod void tokenize_WHITESPACE() {
        List<Lexer.Token> tokens = Lexer.tokenize(' ');
        System.assertEquals(0, tokens.size());
    }
    static testMethod void tokenize_LPAREN() {
        List<Lexer.Token> tokens = Lexer.tokenize('(');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LPAREN, tokens[0].kind);
        System.assertEquals('(', tokens[0].lexeme);
    }
    static testMethod void tokenize_RPAREN() {
        List<Lexer.Token> tokens = Lexer.tokenize(')');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.RPAREN, tokens[0].kind);
        System.assertEquals(')', tokens[0].lexeme);
    }
    static testMethod void tokenize_LOGICALAND_Uppercase() {
        List<Lexer.Token> tokens = Lexer.tokenize('AND');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LOGICALAND, tokens[0].kind);
        System.assertEquals('AND', tokens[0].lexeme);
    }
    static testMethod void tokenize_LOGICALAND_Lowercase() {
        List<Lexer.Token> tokens = Lexer.tokenize('and');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LOGICALAND, tokens[0].kind);
        System.assertEquals('and', tokens[0].lexeme);
    }
    static testMethod void tokenize_LOGICALAND_Randomcase() {
        List<Lexer.Token> tokens = Lexer.tokenize('aNd');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LOGICALAND, tokens[0].kind);
        System.assertEquals('aNd', tokens[0].lexeme);
    }
    static testMethod void tokenize_LOGICALOR_Uppercase() {
        List<Lexer.Token> tokens = Lexer.tokenize('OR');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LOGICALOR, tokens[0].kind);
        System.assertEquals('OR', tokens[0].lexeme);
    }
    static testMethod void tokenize_LOGICALOR_Lowercase() {
        List<Lexer.Token> tokens = Lexer.tokenize('or');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LOGICALOR, tokens[0].kind);
        System.assertEquals('or', tokens[0].lexeme);
    }
    static testMethod void tokenize_LOGICALOR_Randomcase() {
        List<Lexer.Token> tokens = Lexer.tokenize('Or');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LOGICALOR, tokens[0].kind);
        System.assertEquals('Or', tokens[0].lexeme);
    }
    static testMethod void tokenize_InvalidCharacter() {
        List<Lexer.Token> tokens = Lexer.tokenize('b');
        System.assertEquals(0, tokens.size());
    }
    static testMethod void tokenize_InvalidSymbol() {
        List<Lexer.Token> tokens = Lexer.tokenize('@');
        System.assertEquals(0, tokens.size());
    }
    static testMethod void tokenize_sequence() {
        List<Lexer.Token> tokens = Lexer.tokenize('0AND (1OR2 )');
        System.assertEquals(7, tokens.size());
        System.assertEquals(Lexer.Kind.ZERO, tokens[0].kind);
        System.assertEquals(Lexer.Kind.LOGICALAND, tokens[1].kind);
        System.assertEquals(Lexer.Kind.LPAREN, tokens[2].kind);
        System.assertEquals(Lexer.Kind.NUM, tokens[3].kind);
        System.assertEquals(Lexer.Kind.LOGICALOR, tokens[4].kind);
        System.assertEquals(Lexer.Kind.NUM, tokens[5].kind);
        System.assertEquals(Lexer.Kind.RPAREN, tokens[6].kind);
    }
    static testMethod void tokenize_sequence_invalid() {
        List<Lexer.Token> tokens = Lexer.tokenize('HELLO WORLD');
        System.assertEquals(1, tokens.size());
        System.assertEquals(Lexer.Kind.LOGICALOR, tokens[0].kind);
    }
}