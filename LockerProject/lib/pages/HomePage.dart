import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lockerproject/pages/components/GlobalFunctions.dart';
import 'package:lockerproject/pages/loadingPage.dart';

import 'components/wp3.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//görüntü piksellerinin bulunduğu değişkeni oluşturuyoruz
var stringpix;
var lastarry;
final textController = TextEditingController();

bool image4k;
String quote = "This is a very awesome quote";

var imagetmp;
var sList;
var lastarrrrrr;
var fireimg;
var reversedImage;
File _chosenImage;
var list;

Uint8List bmp;
BMP332Header header;
Random r = Random();

var sha3hash;

String BASE64_STRING =
    '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';
Image img = Image.memory(base64Decode(BASE64_STRING));
Uint8List bytesnew = base64Decode(BASE64_STRING);

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  File _image;
  final picker = ImagePicker();

  pickImagefromGallery() async {
    //pick image from gallery
    final image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    //get Image Pixels
    Uint8List bytes = await image.readAsBytes();
    //image hashcode for ram data
    var hashcode = image.hashCode;
    //list değişkeninde bytes de olan verilerin listeye dönüştürülmüş hali vardır
    list = bytes.toList();

    //get Image Resolution
    var decodedImage = await decodeImageFromList(bytes);
    var width = decodedImage.width;
    var height = decodedImage.height;

    print(width.toString());
    print(height.toString());

    //eğer image uzantısı lazım olursa image pathin son 3 hanesi bu değeri verir.
    //print(image.path);

    setState(() {
      //header = BMP332Header(100, 100);
      //bmp = header.appendBitmap(
      //    Uint8List.fromList(List<int>.generate(10000, (i) => r.nextInt(255))));
      //stringpix değişkeninde bytes değişkenin içeriğini atıyoruz
      stringpix = bytes;

      //sList = List<int>.from(fireimg);
      //lastarrrrrr = Uint8List.fromList(sList);
    });
  }

  //bu kısım uygulamadaki kamera çek kısmıdır.
  Future takePhotoFromCamera() async {
    final image = await picker.getImage(source: ImageSource.camera);
    //get Image Pixels
    //get Image Pixels
    Uint8List bytes = await image.readAsBytes();
    //image hashcode for ram data
    var hashcode = image.hashCode;

    var list = bytes.toList();

    //get Image Resolution
    var decodedImage = await decodeImageFromList(bytes);
    var width = decodedImage.width;
    var height = decodedImage.height;

    //eğer image uzantısı lazım olursa image pathin son 3 hanesi bu değeri verir.
    //print(image.path);

    setState(() {
      //header = BMP332Header(100, 100);
      //bmp = header.appendBitmap(
      //    Uint8List.fromList(List<int>.generate(10000, (i) => r.nextInt(255))));

      stringpix = bytes;
    });
  }

  var veri = "";

  bool enc = true;
  bool dec = false;
  var docID;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            child: Image.asset(
              "assets/images/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " CrypIt!",
                                style: TextStyle(
                                    fontFamily: "Inconsolata",
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: InkWell(
                                  onTap: () {
                                    showAlertDialog(context);
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.exclamationCircle,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            enc = true;
                            dec = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width * 0.45,
                          height: 50,
                          decoration: BoxDecoration(
                              color: enc
                                  ? Color(0xffbb2205)
                                  : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Encryption",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                enc = false;
                                dec = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width * 0.45,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: dec
                                      ? Color(0xffbb2205)
                                      : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Decryption",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (enc)
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        stringpix != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width,
                                  height: size.height * 0.3,
                                  child: Image.memory(stringpix),
                                ),
                              )
                            : Container(
                                child: Image.asset(
                                  "assets/images/locker.gif",
                                  width: size.width,
                                  height: size.height * 0.3,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                    color: Color(0xff5c6e91),
                                    borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                  onTap: () {
                                    pickImagefromGallery();
                                  },
                                  child: Text(
                                    "Select Image",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        color: Color(0xff5c6e91),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: InkWell(
                                      onTap: () {
                                        takePhotoFromCamera();
                                      },
                                      child: Text(
                                        "Take\nPhoto",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            var zigzagResult = zigzagFunction(list);
                            //print(list);

                            var keyResult = createSenderKey(stringpix.length);

                            var senderkey =
                                byteConversionFunction(keyResult[0]);
                            var lastResult =
                                xorFunction(zigzagResult, senderkey);
                            var id = await imageToFireStore(
                                keyResult[1], lastResult);
                            showIDBox(context, id);

                            //imageToFireStore([1, 2], list);
                            //imageToFireStore([0, 1], list);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * 0.6,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffbb2205),
                            ),
                            child: Text(
                              "Encrypt It!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "  Send with: ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: "Inconsolata",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.90,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.facebook,
                                        color: Colors.blue,
                                        size: 35,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          launchWhatsApp(docID);
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: Color(0xff34B7F1),
                                          size: 35,
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.telegram,
                                        color: Color(0xff0088cc),
                                        size: 35,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          docID != null ? mailto(docID) : null;
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.solidEnvelopeOpen,
                                          color: Color(0xff0278ae),
                                          size: 35,
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.save,
                                        color: Color(0xff0278ae),
                                        size: 35,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  else
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 15),
                              child: Text(
                                "Please Enter the Reference Number!",
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontFamily: "Inconsolata-Bold"),
                              ),
                            ),
                            Container(
                              width: size.width * 0.74,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 0.0,
                                ),
                                child: TextField(
                                  controller: textController,
                                  style: TextStyle(color: Colors.blue),
                                  cursorColor: Colors.blue,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.blue,
                                    ),
                                    border: InputBorder.none,
                                    hintText:
                                        'Enter 16 digits reference number!',
                                    hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey.withOpacity(0.4)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: reversedImage != null
                                  ? Column(
                                      children: [
                                        Container(
                                          width: size.width * 0.6,
                                          height: size.height * 0.3,
                                          child: Image.memory(reversedImage),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      FontAwesomeIcons.save,
                                                      color: Color(0xff0278ae),
                                                      size: 35,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Save",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(
                                      child: Image.asset(
                                          "assets/images/unlock_animaiton.gif",
                                          width: size.width * 0.6,
                                          height: size.height * 0.3),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          //[137, 80, 78, 71, 13, 10, 26, 10, 0
                          onTap: () async {
                            var list = [];
                            var data = await getimageDatafromFirebase(
                                textController.text.toString());

                            var imageData = data['encryptedImage'].toString();

                            imageData =
                                imageData.substring(1, imageData.length - 1);
                            var lastimage = imageData.split(',');
                            for (var i = 0; i < lastimage.length; i++) {
                              list.add(int.parse(lastimage[i]));
                            }

                            var receiverResult = createReceiverKey(
                                data['startParameter'], list.length);

                            var cenderbyte =
                                byteConversionFunction(receiverResult);
                            print(cenderbyte);

                            var xor = xorFunction(list, cenderbyte);
                            lastarry = zigzagters2(xor);
                            print(lastarry);

                            setState(() {
                              sList = List<int>.from(lastarry);
                              reversedImage = Uint8List.fromList(sList);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * 0.6,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffbb2205),
                            ),
                            child: Text(
                              "Decrypt It!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  imageToFireStore(key, bytes) async {
    var shareName = DateTime.now().microsecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection("imageData")
        .doc(shareName)
        .set({
      "startParameter": key,
      "encryptedImage": bytes.toString(),
      "Id": shareName.toString(),
    });
    setState(() {
      docID = shareName;
    });
    print("başarılı");
    return docID;

    /*await FirebaseFirestore.instance
      .collection("imageData")
      .doc("1611056393857651")
      .delete();*/
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("App Usage"),
    content: Text(
        "-Encryption:\n1) Select an Image or Take a Photo.\n2) Press Encrypt Button. \n3) Choose the Send Options\n4) Thats it.\n\n  -Decryption:\n1) Select an Image.\n2) Press Decryption Button. \n3) Thats it."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showIDBox(BuildContext context, docID) async {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Your Reference ID is"),
    content: Text("Image Reference ID: \n " + docID.toString()),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class BMP332Header {
  int _width; // NOTE: width must be multiple of 4 as no account is made for bitmap padding
  int _height;

  Uint8List _bmp;
  int _totalHeaderSize;

  BMP332Header(this._width, this._height) : assert(_width & 3 == 0) {
    int baseHeaderSize = 54;
    _totalHeaderSize = baseHeaderSize + 1024; // base + color map
    int fileLength = _totalHeaderSize + _width * _height; // header + bitmap
    _bmp = new Uint8List(fileLength);
    ByteData bd = _bmp.buffer.asByteData();
    bd.setUint8(0, 0x42);
    bd.setUint8(1, 0x4d);
    bd.setUint32(2, fileLength, Endian.little); // file length
    bd.setUint32(10, _totalHeaderSize, Endian.little); // start of the bitmap
    bd.setUint32(14, 40, Endian.little); // info header size
    bd.setUint32(18, _width, Endian.little);
    bd.setUint32(22, _height, Endian.little);
    bd.setUint16(26, 1, Endian.little); // planes
    bd.setUint32(28, 8, Endian.little); // bpp
    bd.setUint32(30, 0, Endian.little); // compression
    bd.setUint32(34, _width * _height, Endian.little); // bitmap size
    // leave everything else as zero

    // there are 256 possible variations of pixel
    // build the indexed color map that maps from packed byte to RGBA32
    // better still, create a lookup table see: http://unwind.se/bgr233/
    for (int rgb = 0; rgb < 256; rgb++) {
      int offset = baseHeaderSize + rgb * 4;

      int red = rgb & 0xe0;
      int green = rgb << 3 & 0xe0;
      int blue = rgb & 6 & 0xc0;

      bd.setUint8(offset + 3, 255); // A
      bd.setUint8(offset + 2, red); // R
      bd.setUint8(offset + 1, green); // G
      bd.setUint8(offset, blue); // B
    }
  }

  /// Insert the provided bitmap after the header and return the whole BMP
  Uint8List appendBitmap(Uint8List bitmap) {
    int size = _width * _height;
    assert(bitmap.length == size);
    _bmp.setRange(_totalHeaderSize, _totalHeaderSize + size, bitmap);
    return _bmp;
  }
}
