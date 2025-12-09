import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart' hide Hmac;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CryptoDemoPage(),
    ),
  );
}

// ---------------------------------------------------------------------
//  SecureDataService
// ---------------------------------------------------------------------

class SecureDataService {
  final flutterSecureStorage = const FlutterSecureStorage();
  encrypt.IV? currentIv;

  // 1. Derive a key from a password
  Future<encrypt.Key> deriveKey(String password, List<int> salt) async {
    // Argon2id is a password-hashing algorithm
    // that is resistant to side-channel attacks
    final algorithm = Argon2id(
      parallelism: 4,
      memory: 10000, // 10 MB
      iterations: 3,
      hashLength: 32,
    );

    // Derive a key from the password
    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      // use salt as random bytes to make the key unique
      nonce: salt,
    );

    final secretKeyBytes = await secretKey.extractBytes();
    // get the key as a list of bytes
    return encrypt.Key(Uint8List.fromList(secretKeyBytes));
  }

  // 2. Store the key in a secure storage for later use
  Future<void> storeSecretKey(encrypt.Key key, String keyName) async {
    await flutterSecureStorage.write(
      key: keyName,
      value: base64Encode(key.bytes),
    );
  }

  // 3. Retrieve the key from the secure storage when needed
  Future<encrypt.Key?> getSecretKey(String keyName) async {
    final keyString = await flutterSecureStorage.read(key: keyName);
    if (keyString == null) return null;
    return encrypt.Key(base64Decode(keyString));
  }

  // 4. Generate a random salt
  List<int> generateSalt() {
    // always generate strong random
    return encrypt.SecureRandom(16).bytes;
  }

  // 5. Encrypt and decrypt data
  // using the key you derived
  Future<String> encryptData(String data, encrypt.Key key) async {
    // IV Represents an Initialization Vector.
    final iv = encrypt.IV.fromLength(16);
    currentIv = iv; // store for later
    // Encrypter wraps an encrypt.
    // Algorithm in a Unique Container.
    // AES is a symmetric encryption algorithm
    // that uses the same key for
    // both encryption and decryption
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Encrypt data using AES with the given key and IV
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  // 6. Decrypt data using the key you derived
  Future<String> decryptData(String encryptedData, encrypt.Key key) async {
    final iv = currentIv ?? encrypt.IV.fromLength(16);

    // Encrypter wraps an encrypt.
    // Algorithm in a unique Container.
    final encrypter = encrypt.Encrypter(
      // Same algorithm and key used for encryption
      encrypt.AES(key),
    );

    // Decrypt data using AES with the same key and IV
    return encrypter.decrypt64(encryptedData, iv: iv);
  }
}

class CryptoDemoPage extends StatefulWidget {
  const CryptoDemoPage({super.key});

  @override
  State<CryptoDemoPage> createState() => _CryptoDemoPageState();
}

class _CryptoDemoPageState extends State<CryptoDemoPage> {
  String encryptionOutput = "";
  String hashingOutput = "";

  // ---------------------------------------------------------------------
  // MAIN() EXAMPLE FROM CHAPTER — RUN IN UI
  // ---------------------------------------------------------------------

  Future<void> runEncryptionExample() async {
    // ----------------------------------------
    final secureDataService = SecureDataService();
    // Imagine Password is provided by the user
    const password = 'userPassword';

    // Implement this to generate a random salt
    final salt = secureDataService.generateSalt();

    // Derive and store the key
    final key = await secureDataService.deriveKey(password, salt);
    await secureDataService.storeSecretKey(key, 'myEncryptionKey');
    // ----------------------------------------

    // ----------------------------------------
    // Encrypt data
    final encryptedData = await secureDataService.encryptData(
      'Sensitive data',
      key,
    );

    // Decrypt data
    final decryptedData = await secureDataService.decryptData(
      encryptedData,
      key,
    );

    print('Encrypted Data: $encryptedData');
    print('Decrypted Data: $decryptedData');
    // ----------------------------------------
    // print results (now shown in UI)
    setState(() {
      encryptionOutput =
          "Encrypted Data: $encryptedData\nDecrypted Data: $decryptedData";
    });
  }

  // ---------------------------------------------------------------------
  // HASHING EXAMPLE
  // ---------------------------------------------------------------------

  void runHashingExample() {
    // Example String
    String text = 'Hello, world!';

    // SHA-256 Hash
    var bytes1 = utf8.encode(text); // data being hashed
    var sha256Result = sha256.convert(bytes1);

    // MD5 Hash
    var md5Result = md5.convert(bytes1);

    // HMAC SHA-256
    var key = utf8.encode('secret key'); // secret key for HMAC
    var hmacSha256 = Hmac(sha256, key); // HMAC SHA256
    var hmacResult = hmacSha256.convert(bytes1);

    print('HMAC SHA-256: $hmacResult');
    setState(() {
      hashingOutput =
          "SHA-256 hash: $sha256Result\n"
          "MD5 hash: $md5Result\n"
          "HMAC SHA-256: $hmacResult";
    });
  }

  // ---------------------------------------------------------------------
  // UI WRAPPER
  // ---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chapter 19 Cryptography Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: runEncryptionExample,
              child: const Text("Run Encryption Example (Exact Chapter Code)"),
            ),
            Text(encryptionOutput),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: runHashingExample,
              child: const Text("Run Hashing Example (Exact Chapter Code)"),
            ),
            Text(hashingOutput),
          ],
        ),
      ),
    );
  }
}

