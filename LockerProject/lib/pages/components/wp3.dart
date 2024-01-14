import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:pointycastle/asymmetric/api.dart';
// SON GÜNCELLEME TARİHİ : 30.12.2020

// Kullanım Şekli

// Gönderici Anahtarı Oluşturmak İçin
// ==> var senderKey = createSenderKey(int okunan_byte_değerlerinin_uzunluğu);
// Gönderici Anahtarı için kodu yazın
// ==> print(senderKey[0]);
// Kullanılan Başlangıç Değerlerinin İndexleri için kodu yazın
// ==> print(senderKey[1]);

// Alıcı Anahtarı Oluşturmak İçin
// ==> var receiverKey = createReceiverKey(Gelen_Başlangıç_Değerlerinin_İndexleri[], int okunan_byte_değerlerinin_uzunluğu);
// Alıcı Anahtarı için kodu yazın
// ==> print(receiverKey);

// Gönderici için anahtar üreten fonksiyon.

List createSenderKey(var bytes) {
  // wp2Out ==> Hocanın verdiği değerlerdir. Değiştirilmemesi gerekir.
  var wp2Out = [
    0.868108929091533,
    0.436522798444119,
    0.850347542213392,
    0.775550139264662,
    0.752164288690584,
    0.117648319430803,
    0.838178032758474
  ];
  var randomArray = randArr(wp2Out, bytes);
  return randomArray;
}

List randArr(var wp2Out, var bytes) {
  var t = bytes * 8;
  var tempRandArr = [];
  var randArr = [];
  // Kullanılan başlangıç değerlerinin indisleri.
  var start_values_indices = [];
  while (true) {
    var start_velue_index = (wp1() % 7);
    var start_value = wp2Out[start_velue_index];
    start_values_indices.add(start_velue_index);
    if (t > tempRandArr.length) {
      tempRandArr.addAll(randomBin(start_value));
    } else {
      break;
    }
  }
  for (var i = 0; i < t; i++) {
    randArr.add(tempRandArr[i]);
  }
  // Son güncellemede başlangıç değerleri yerine dizideki indis değerleri geri döndürülmektedir.
  return [randArr, start_values_indices];
}

// Rastgele 1 milyon bit üreten fonksiyon.
List randomBin(var wp2Out) {
  var xEx = wp2Out;
  var randSize = 1000000;
  var rand = List(randSize);
  for (var i = 0; i < randSize; i++) {
    var xNew = xEx * (1 - xEx) * 4;
    if (xNew < 0.5) {
      rand[i] = 0;
    } else {
      rand[i] = 1;
    }
    xEx = xNew;
  }
  return rand;
}

// Alıcı için başlangıç değerleriyle anahtar üreten fonksiyon.
List createReceiverKey(var start_values_indices, var bytes) {
  var t = bytes * 8;
  var tempRandArr = [];
  var randArr = [];
  var wp2Out = [
    0.868108929091533,
    0.436522798444119,
    0.850347542213392,
    0.775550139264662,
    0.752164288690584,
    0.117648319430803,
    0.838178032758474
  ];
  var start_value;

  for (var i = 0; i < (start_values_indices.length); i++) {
    start_value = wp2Out[start_values_indices[i]];
    if (t > tempRandArr.length) {
      tempRandArr.addAll(randomBin(start_value));
    } else {
      break;
    }
  }
  for (var i = 0; i < t; i++) {
    randArr.add(tempRandArr[i]);
  }
  return randArr;
}

// İş Paketi 1 Ramden Veri Okuma, SHA-3 ten geçirerek int değere dönüştürme.
int wp1() {
  var a = [].hashCode.toString();
  var t = [].hashCode.toString();

  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);

  final encrypterforAES = Encrypter(AES(key));
  final encryptedAES = encrypterforAES.encrypt(t, iv: iv);

  final iv1 = IV.fromLength(8);

  final encrypterforSalsa = Encrypter(Salsa20(key));
  final encryptedSALSA = encrypterforSalsa.encrypt(t, iv: iv1);

  rsaEncrypter() async {
    final publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
    final privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');

    final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));
  }

  var k = SHA3(256, KECCAK_PADDING, 256);
  k.update(utf8.encode(a));
  var hash = k.digest();
  var myHex = (HEX.encode(hash)).toString();
  var wp1OutArr = [];
  var wp1Out = 0;
  for (var i = 0; i <= myHex.length - 8; i += 8) {
    final hex = myHex.substring(i, i + 8);
    final number = int.parse(hex, radix: 16);
    wp1OutArr.add(number);
  }
  for (var i = 0; i < wp1OutArr.length; i++) {
    if (wp1OutArr[i] != null) {
      wp1Out += wp1OutArr[i];
    }
  }

  return wp1Out;
}

void main(List<String> args) {
  var a = createSenderKey(15);

  var b = createReceiverKey([4, 4], 15);
  print(b);
}
