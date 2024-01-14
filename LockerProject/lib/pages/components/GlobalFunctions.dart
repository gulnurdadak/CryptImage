import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

zigzagFunction(arry) {
  //düzgün listemizin ilk kısmı mod2 ye göre "sadece indis işlemi yapılıyor" karıştırılıyor tekrar eden bir kural vardır
  var I_arry2 = [];
  var I_arry3 = [];
  var I_arry4 = [];

  //mod2 den çıkan mod5 e göre "sadece indis işlemi yapılıyor" karıştırılıyor tekrar eden bir kural vardır
  for (var i = 0; i < arry.length; i++) {
    if (i % 5 == 0) {
      I_arry3.insert(0, arry[i]);
    } else {
      I_arry3.add(arry[i]);
    }
  }
  //mod5 den çıkan mod3 e göre "sadece indis işlemi yapılıyor" karıştırılıyor tekrar eden bir kural vardır

  //en son I_arry4 listemiz oluşuyor belli bir kurala göre karıştırılmış listemiz tipi int dir
  //Bu fonksiyonun tamamı Hüseyin Bitikçi ve Sümeyye Gülnur Dadak tarafından oluşturulmuştur elimize sağlık...
  return I_arry3;
}

decimaltoBinaryFunction(arry) {
  var I_binaryList = [];
  var I_lastArr = [];
  for (var i = 0; i < arry.length; i++) {
    //burada gelen decimal değerleri binary'e dönüştürüyoruz
    I_binaryList.add(int.parse(arry[i].toString(), radix: 10).toRadixString(2));
  }
  return I_binaryList;
}

divisonHexFunction(List arry) {
  var I_binaryList = arry;
  var I_lastArr = [];
  //divisonHexFunction fonksiyonu binary olan dizimizi hem 8'lik bişekilde oluşturuyor hemde ayırıyor
  //101 değişkeni olsun diyelim tabi hiç bir dilde başındaki 0 ları görmez fonksiyon ise 0,0,0,0,0,1,0,1 olacak şekilde ayırıyor
  //bunun sebebi ise keyimiz ile aynı uzunlukta değerlerin olması daha sonra bu değerleri xor işlemine tabi tutmak
  for (var j = 0; j < I_binaryList.length; j++) {
    var I_a = I_binaryList[j].toString();
    var I_uzunluk = 8 - I_a.length;
    var tempArr = [('1' + '0' * I_uzunluk + I_a)];
    for (var k = 1; k < tempArr[0].length; k++) {
      I_lastArr.add(int.parse(tempArr[0][k]));
    }
  }
  //I_lastArr içindeki değerler string ve her biri ayrı şekildedir 0,1,0,1,1,0,1,0 gibi
  return I_lastArr;
}

//Key and image array after zigzag func.
xorFunction(I_arry1, I_arry2) {
  var I_a = I_arry1;
  var I_b = I_arry2;
  var I_c = [];
  for (var i = 0; i < I_b.length; i++) {
    I_c.add(I_a[i] ^ I_b[i]);
  }
  return I_c;
}

byteConversionFunction(arry) {
  //fonksiyon gelen binary listemizi 8 erli bir şekilde ayırıp onu decimal tabanda yazılmasını sağlar
  var I_c = arry;
  var I_arry1 = [];
  var STR_z = '';
  for (var i = 0; i < I_c.length; i++) {
    STR_z += I_c[i].toString();
    //8 li 8 li ayrılması için if satırı gelen uzunluk değerinin 8 e bölümünden kalan 7 olursa 0 dan
    //başladığımız için diğer işlemler çalışmakta
    if (i % 8 == 7) {
      //her 8 linin decimal halini tutmakta
      var I_sum = 0;
      for (var j = 0; j < STR_z.length; j++) {
        if (STR_z[j] == "1") {
          //STR_Z stringinin hangi indisinde 1 varsa o indisi 2 nin üstü olarak alınmakta
          var I_i = pow(2, 7 - j).toString(); //2 lik tabana çevirme
          I_sum += int.parse(I_i);
        }
      }

      I_arry1.add(I_sum);

      STR_z = '';
    }
  }
  //I_arry1 tipi int dizisi image.memory ye gönderilicek
  return I_arry1;
}

reversezigZagFunction(Iarry) {
  //Girdi list[int]
  //ilk başta karışık olan arry'in yaptığımız işlemlerin
  //tersinin ilk basamağı olan mod3 ün çıktısının tersini yapıyoruz
  var I_BYTELIST = Iarry;
  var I_DEGISKENLIST1 = [];
  var I_DEGISKENLIST2 = [];
  var I_DEGISKENLIST3 = [];
  //Flutter platformunda length fonksiyonu float bir değer üretiyor bunu int direk çevirince yuvarlamakta biz ilk önce strin yapıp sonra ilk elemanını int çeviriyoruz
  var STR_BYTE_LIST_LEN = ((I_BYTELIST.length - 1) / 3).toString();
  var I_BYTE_LIST_LEN = int.parse(STR_BYTE_LIST_LEN[0]);
  var I_DEGISKEN1 = 0;
  var I_DEGISKEN2 = 1;
  var I_DEGISKEN3 = 0;
  for (var i = 0; i < I_BYTE_LIST_LEN; i++) {
    I_DEGISKENLIST1.add(I_BYTELIST[i]);
  }
  for (var i = I_BYTE_LIST_LEN; i < I_BYTELIST.length; i++) {
    I_DEGISKENLIST2.add(I_BYTELIST[i]);
  }
  I_DEGISKENLIST3.add(I_DEGISKENLIST2[0]);

  I_DEGISKENLIST1 = I_DEGISKENLIST1.reversed.toList();
  while (true) {
    if (I_DEGISKEN1 == I_DEGISKENLIST2.length - 1) {
      break;
    }
    I_DEGISKENLIST3.add(I_DEGISKENLIST2[I_DEGISKEN2]);
    if ((I_DEGISKEN2 % 2 == 0) && (I_DEGISKEN3 < I_DEGISKENLIST1.length)) {
      I_DEGISKENLIST3.add(I_DEGISKENLIST1[I_DEGISKEN3]);
      I_DEGISKEN3++;
    }
    I_DEGISKEN2++;
    I_DEGISKEN1++;
  }
  //I_DEGISKENLIST3 bizim mod3'e göre olan kısmın düzeltilmiş hali bunu mod5 için tersine uyguluyoruz
  I_BYTELIST = I_DEGISKENLIST3;
  I_DEGISKENLIST1 = [];
  I_DEGISKENLIST2 = [];
  var I_BYTE_LIST_LEN1 = 0;
  if ((I_BYTELIST.length % 5 == 1) || (I_BYTELIST.length % 5 == 2)) {
    I_BYTE_LIST_LEN1 = (I_BYTELIST.length / 5).round();
  } else {
    I_BYTE_LIST_LEN1 = (I_BYTELIST.length / 5 - 1).round();
  }
  for (var i = I_BYTE_LIST_LEN1; i >= 0; i--) {
    I_DEGISKENLIST1.add(I_BYTELIST[i]);
  }
  for (var i = I_BYTE_LIST_LEN1 + 1; i < I_BYTELIST.length; i++) {
    I_DEGISKENLIST2.add(I_BYTELIST[i]);
  }
  I_DEGISKEN1 = 0;
  I_DEGISKEN2 = 0;
  I_DEGISKEN3 = 0;
  I_DEGISKENLIST3 = [];
  while (true) {
    if (I_DEGISKEN1 == I_BYTELIST.length) {
      break;
    }
    if (I_DEGISKEN1 % 5 == 0) {
      I_DEGISKENLIST3.add(I_DEGISKENLIST1[I_DEGISKEN2]);
      I_DEGISKEN2++;
    } else {
      I_DEGISKENLIST3.add(I_DEGISKENLIST2[I_DEGISKEN3]);
      I_DEGISKEN3++;
    }
    I_DEGISKEN1++;
  }
  //burada ise yaptığımız karıştırmanın en son hali olan mod2 kısmını hallediyoruz ve bize
  //ilk gönderilen arry sırasını veriyor
  I_BYTELIST = I_DEGISKENLIST3;
  I_DEGISKENLIST1 = [];
  var F_LEN = I_BYTELIST.length;
  if (F_LEN % 2 == 0) {
    var I_DEGISKEN1 = (F_LEN / 2 - 1).round();
    var I_DEGISKEN2 = (F_LEN / 2 - 0.1).round();
    for (var i = 0; i < I_BYTELIST.length / 2; i++) {
      I_DEGISKENLIST1.add(I_BYTELIST[I_DEGISKEN1]);
      I_DEGISKEN1--;
      I_DEGISKENLIST1.add(I_BYTELIST[I_DEGISKEN2]);
      I_DEGISKEN2++;
    }
  } else {
    I_DEGISKEN1 = (F_LEN / 2 - 0.1).round();
    I_DEGISKEN2 = (F_LEN / 2).round();

    for (var i = 0; i < (F_LEN / 2 - 1).round(); i++) {
      I_DEGISKENLIST1.add(I_BYTELIST[I_DEGISKEN1]);
      I_DEGISKEN1--;
      I_DEGISKENLIST1.add(I_BYTELIST[I_DEGISKEN2]);
      I_DEGISKEN2++;
    }
    I_DEGISKENLIST1.add(I_BYTELIST[I_DEGISKEN1]);
  }
  //enson çıkan düzgün listemiz
  //Bu fonksiyonun tamamı Hüseyin Bitikçi ve Sümeyye Gülnur Dadak tarafından oluşturulmuştur elimize sağlık...
  //çıktı int
  return I_DEGISKENLIST1;
}

zigzagters2(arry) {
  var I_BYTELIST = arry;
  var I_DEGISKENLIST1 = [];
  var I_DEGISKENLIST2 = [];
  var I_BYTE_LIST_LEN1 = 0;
  if ((I_BYTELIST.length % 5 == 1) || (I_BYTELIST.length % 5 == 2)) {
    I_BYTE_LIST_LEN1 = (I_BYTELIST.length / 5).round();
  } else {
    I_BYTE_LIST_LEN1 = (I_BYTELIST.length / 5 - 1).round();
  }
  for (var i = I_BYTE_LIST_LEN1; i >= 0; i--) {
    I_DEGISKENLIST1.add(I_BYTELIST[i]);
  }
  for (var i = I_BYTE_LIST_LEN1 + 1; i < I_BYTELIST.length; i++) {
    I_DEGISKENLIST2.add(I_BYTELIST[i]);
  }
  var I_DEGISKEN1 = 0;
  var I_DEGISKEN2 = 0;
  var I_DEGISKEN3 = 0;
  var I_DEGISKENLIST3 = [];
  while (true) {
    if (I_DEGISKEN1 == I_BYTELIST.length) {
      break;
    }
    if (I_DEGISKEN1 % 5 == 0) {
      I_DEGISKENLIST3.add(I_DEGISKENLIST1[I_DEGISKEN2]);
      I_DEGISKEN2++;
    } else {
      I_DEGISKENLIST3.add(I_DEGISKENLIST2[I_DEGISKEN3]);
      I_DEGISKEN3++;
    }
    I_DEGISKEN1++;
  }
  return I_DEGISKENLIST3;
}

postIslemiYap(arrL) async {
  await http
      .post(
        "http://ymgkip4.azure-api.net/HttpTrigger1",
        body: jsonEncode(<String, String>{
          'body': arrL.toString(),
        }),
      )
      .then((cevap) {});
}

getimageDatafromFirebase(dataID) async {
  var data = await FirebaseFirestore.instance
      .collection("imageData")
      .doc(dataID.toString())
      .get();

  return data;
}

mailto(docID) {
  final Uri _emailLaunchUri = Uri(scheme: 'mailto', queryParameters: {
    'subject': 'CrypIt! Your Reference ID.',
    'body': 'Your Encrypted Image Reference ID is ' + docID.toString()
  });

// ...

// mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
  launch(_emailLaunchUri.toString());
}

launchWhatsApp(docID) async {
  final link = WhatsAppUnilink(
    text: "CrypIt! - Your Reference ID is " + docID.toString(),
  );
  await launch('$link');
}
