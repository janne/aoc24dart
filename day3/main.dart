import 'dart:io';

class Token {
  final String _content;

  const Token(this._content);

  String get content => _content;
}

class Identifier extends Token {
  Identifier(super.content);

  @override
  String toString() {
    return "Identifier($_content)";
  }
}

class Number extends Token {
  Number(super.content);

  int get asNumber => int.parse(_content);

  @override
  String toString() {
    return "Number($_content)";
  }
}

class Symbol extends Token {
  Symbol(super.content);

  bool get isOpen => _content == "(";

  @override
  String toString() => "Symbol($_content)";
}

class Garbage extends Token {
  Garbage(super.content);

  @override
  String toString() => "Garbage($_content)";
}

bool isString(String c) => RegExp(r"[a-zA-Z']").hasMatch(c);
bool isNumber(String c) => RegExp(r"[0-9]").hasMatch(c);
bool isSymbol(String c) => RegExp(r"[(),]").hasMatch(c);

enum State {
  number,
  identifier,
  garbage,
  none;
}

List<Token> tokenize(String input) {
  final List<Token> tokens = [];

  State state = State.none;
  String token = "";

  for (String c in input.split("")) {
    if (isString(c)) {
      switch (state) {
        case State.number:
          tokens.add(Number(token));
          token = c;
          state = State.number;
          break;
        case State.identifier:
          token += c;
          break;
        case State.garbage:
          tokens.add(Garbage(token));
          state = State.identifier;
          token = c;
          break;
        case State.none:
          state = State.identifier;
          token = c;
          break;
      }
    } else if (isNumber(c)) {
      switch (state) {
        case State.number:
          token += c;
          break;
        case State.identifier:
          tokens.add(Identifier(token));
          token = c;
          break;
        case State.garbage:
          tokens.add(Garbage(token));
          state = State.number;
          token = c;
        case State.none:
          state = State.number;
          token = c;
          break;
      }
    } else if (isSymbol(c)) {
      switch (state) {
        case State.number:
          tokens.add(Number(token));
          tokens.add(Symbol(c));
          state = State.none;
          token = "";
          break;
        case State.identifier:
          tokens.add(Identifier(token));
          tokens.add(Symbol(c));
          state = State.none;
          token = "";
          break;
        case State.garbage:
          tokens.add(Garbage(token));
          tokens.add(Symbol(c));
          state = State.none;
          token = "";
          break;
        case State.none:
          tokens.add(Symbol(c));
          break;
      }
    } else {
      switch (state) {
        case State.number:
          tokens.add(Number(token));
          state = State.garbage;
          token = c;
          break;
        case State.identifier:
          tokens.add(Identifier(token));
          state = State.garbage;
          token = c;
          break;
        case State.garbage:
          state = State.garbage;
          token += c;
          break;
        case State.none:
          state = State.garbage;
          token = c;
          break;
      }
    }
  }

  switch (state) {
    case State.number:
      tokens.add(Number(token));
      break;
    case State.identifier:
      tokens.add(Identifier(token));
      break;
    case State.garbage:
      tokens.add(Garbage(token));
      break;
    case State.none:
      break;
  }

  return tokens;
}

List<int> parseDay1(List<Token> tokens) {
  int i = 0;
  final result = <int>[];
  while (i < tokens.length) {
    if (tokens[i] is Identifier && tokens[i].content.endsWith("mul") && tokens.length >= i + 5) {
      final symbols = [tokens[i + 1], tokens[i + 3], tokens[i + 5]];
      final arg1 = tokens[i + 2];
      final arg2 = tokens[i + 4];
      if (symbols.every((symbol) => symbol is Symbol && symbols.map((s) => s.content).join("") == "(,)") && arg1 is Number && arg2 is Number) {
        result.add(arg1.asNumber * arg2.asNumber);
        i += 5;
      }
    }
    i++;
  }
  return result;
}

List<int> parseDay2(List<Token> tokens) {
  int i = 0;
  final result = <int>[];
  bool enabled = true;
  while (i < tokens.length) {
    final token = tokens[i];
    if (token is Identifier && (token.content.endsWith("do") || token.content.endsWith("don't")) && tokens.length >= i + 2) {
      final symbols = [tokens[i + 1], tokens[i + 2]];
      if (symbols.every((s) => s is Symbol) && symbols.map((s) => s.content).join("") == "()") {
        enabled = token.content.endsWith("do");
        i += 2;
      }
    } else if (token is Identifier && token.content.endsWith("mul") && tokens.length >= i + 5 && enabled) {
      final symbols = [tokens[i + 1], tokens[i + 3], tokens[i + 5]];
      final arg1 = tokens[i + 2];
      final arg2 = tokens[i + 4];
      if (symbols.every((symbol) => symbol is Symbol && symbols.map((s) => s.content).join("") == "(,)") && arg1 is Number && arg2 is Number) {
        result.add(arg1.asNumber * arg2.asNumber);
        i += 5;
      }
    }
    i++;
  }
  return result;
}

void main() async {
  final tokenizedInput = tokenize(await File('day3/input').readAsString());

  final part1 = parseDay1(tokenizedInput).reduce((a, b) => a + b);
  print("part1: $part1");

  final part2 = parseDay2(tokenizedInput).reduce((a, b) => a + b);
  print("part2: $part2");
}
