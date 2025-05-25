import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/setting/setting_service.dart';
final settingsService = SettingsService();


final textStyleOdo =  TextStyle(
    fontSize: settingsService.settings!.textOdoSize,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.normal,
    shadows: [
      Shadow(
        color: Colors.orangeAccent,
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  );
final textStyleJPHit = TextStyle(
      fontSize: settingsService.settings!.textHitPriceSize,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: const [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    );
    final textStyleSmall = TextStyle(
      fontSize: settingsService.settings!.textHitNumberSize,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    );
const textStyleOdoSmall =  TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.normal,
    shadows: [
      Shadow(
        color: Colors.orangeAccent,
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  );

Widget textWidget(){
  return Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding:const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color:Colors.white54),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(
            "\$14,000",
            style: TextStyle(
              fontSize: 72.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ],
);
}



// APIs
// 1. Thêm 1 sản phẩm food mới (POST)
// id : Object
// name : String
// note  :String
// imageUrl : String  (default: "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg")
// active: Boolean (default:true)
// createAt : DateTime
// updateAt : DateTime

// 2. danh sách các sp đã thêm (GET)

// 3. Update 1 sản phẩn theo id (PUT)
// id : Object
// name : String
// note  :String
// imageUrl : String  (default: "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg")
// active: Boolean (default:true)
// createAt : DateTime
// updateAt : DateTime

// 4.Xoá sp theo id (DELETE)
// 5. Upload image url rồi update lại foods
