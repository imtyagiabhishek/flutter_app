import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/CartListBloc.dart';
import 'package:flutter_app/bloc/listTileColorBloc.dart';
import 'package:flutter_app/cart.dart';
import 'package:flutter_app/model/food_item.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        //add yours BLoCs controlles
        Bloc((i) => CartListBloc()),
        Bloc((i) => ColorBloc()),
      ],
      child: MaterialApp(
        title: "Food Delivery",
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to foodies'),
          elevation: 2.0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    FirstHalf(),
                    SizedBox(
                      height: 45,
                    ),
                    for (var foodItem in fooditemList.foodItems)
                      Builder(
                        builder: (context) {
                          return ItemContainer(foodItem: foodItem);
                        },
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } //Widget
}

class ItemContainer extends StatelessWidget {
  ItemContainer({
    @required this.foodItem,
  });
  final FoodItem foodItem;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(FoodItem foodItem) {
    bloc.addToList(foodItem);
  } //addToCart

  removeFromList(FoodItem foodItem) {
    bloc.removeFromList(foodItem);
  } //removeFromList

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addToCart(foodItem);
        final snackbar = SnackBar(
          content: Text('${foodItem.title} added to cart'),
          duration: Duration(milliseconds: 500),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
      child: Items(
        hotel: foodItem.hotel,
        itemName: foodItem.title,
        itemPrice: foodItem.price,
        imgUrl: foodItem.imgUrl,
        leftAligned: (foodItem.id % 2) == 0 ? true : false,
      ),
    );
  } //Widget
} //ItemContainer

class Items extends StatelessWidget {
  Items({
    @required this.leftAligned,
    @required this.imgUrl,
    @required this.itemName,
    @required this.itemPrice,
    @required this.hotel,
  });

  final bool leftAligned;
  final double itemPrice;
  final String imgUrl;
  final String itemName;
  final String hotel;

  @override
  Widget build(BuildContext context) {
    double containerPadding = 45;
    double containerBorderRadious = 10;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: leftAligned ? 0 : containerPadding,
            right: leftAligned ? containerPadding : 0,
          ),
          child: Column(
            children: [
              Container(
                // width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: leftAligned
                        ? Radius.circular(0)
                        : Radius.circular(containerBorderRadious),
                    right: leftAligned
                        ? Radius.circular(containerBorderRadious)
                        : Radius.circular(0),
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: leftAligned ? 20 : 0,
                  right: leftAligned ? 0 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          itemName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        )),
                        Text(
                          '\$$itemPrice',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                              children: [
                                TextSpan(text: 'by '),
                                TextSpan(
                                    text: hotel,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: containerPadding,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ); //Column
  } //Widget

} //Items

class FirstHalf extends StatelessWidget {
  const FirstHalf({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
      child: Column(
        children: [
          CustomAppBar(),
          SizedBox(
            height: 30,
          ),
          title(),
          SizedBox(
            height: 30,
          ),
          searchBar(),
          SizedBox(
            height: 45,
          ),
          categories(),
        ],
      ),
    ); //return
  } //widget
} //FirstHalf

Widget categories() {
  return Container(
    height: 185,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        CategoryListItem(
          categoryIcon: Icons.fastfood,
          categoryName: "Burger",
          availability: 12,
          selected: true,
        ), //CategoryListItem
      ],
    ),
  ); //Container
} //categories

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    Key key,
    @required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.selected,
  }) : super(key: key);

  final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        // color: selected ? Themes.color : Colors.white,
        border: Border.all(
          color: selected ? Colors.transparent : Colors.grey[300],
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100],
            blurRadius: 15,
            offset: Offset(15, 0),
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: selected ? Colors.transparent : Colors.grey[100],
                width: 1.5,
              ),
            ),
            child: Icon(
              categoryIcon,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            categoryName,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 6, 0, 10),
            width: 1.5,
            height: 1.5,
            color: Colors.black26,
          ),
          Text(
            availability.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          )
        ],
      ),
    ); //Container
  } //return

} //CategoryListItem

Widget searchBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Icon(
        Icons.search_sharp,
        color: Colors.blueGrey,
      ),
      SizedBox(
        width: 20,
      ),
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search",
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            hintStyle: TextStyle(color: Colors.blueGrey),
            border:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
      ),
    ],
  ); //Row
} //searchBar

Widget title() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        height: 45,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Food',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
          ),
          Text(
            'Delivery',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
          ),
        ],
      ),
    ],
  ); //Row
} //title

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu_rounded),
          StreamBuilder(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<FoodItem> foodItems = snapshot.data;
              int length = foodItems != null ? foodItems.length : 0;
              return buildGuestureDetector(length, context, foodItems);
            },
          )
        ],
      ),
    ); //return
  }

  GestureDetector buildGuestureDetector(
      int length, BuildContext context, List<FoodItem> foodItems) {
    return GestureDetector(
      onTap: () {
        if (length > 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        } else {
          return;
        }
      }, //onTap
    ); //Return
  } //GestureDetector

} //CustomAppBar
