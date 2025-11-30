void main() {
  const testValue = String.fromEnvironment('TEST');
  print('TEST VALUE: $testValue');
  print('Is empty? ${testValue.isEmpty}');
}