import 'package:flutter/material.dart';

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
