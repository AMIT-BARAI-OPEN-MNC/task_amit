import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/core/services/navigationServices.dart';
import 'package:task_amit/core/uttils/colors.dart';
import 'package:task_amit/core/uttils/responsiveSizeHelper.dart';
import 'package:task_amit/data/search_model.dart';
import 'package:task_amit/logic/home_screen_bloc.dart';
import 'package:task_amit/logic/search_Bloc.dart';
import 'package:task_amit/router/pageName.dart';
import 'package:task_amit/views/screens/navbar/detailsScreen.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  final List<String> categories = const ["Most Viewed", "Nearby", "Latest"];

  final List<Map<String, String>> places = const [
    {
      "title": "Mount Fuji, Tokyo",
      "location": "Tokyo, Japan",
      "image": "assets/images/mountain.png"
    },
    {
      "title": "Andes, South America",
      "location": "South America",
      "image": "assets/images/flutter_assement_details.png"
    },
    {
      "title": "Swiss Alps",
      "location": "Switzerland",
      "image": "assets/images/person.jpeg"
    },
  ];

  //  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.height;
    double width = SizeConfig.width;
    double textsize = SizeConfig.textSize;

    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    // double textsize = height * 0.03;
    //  double textsize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: height * 0.015),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.06),
              userProfileHeader(height: height, textsize: textsize),
              SizedBox(height: height * 0.023),
              searchBar(context),
              SizedBox(height: height * 0.03),

              // Show search results dynamically
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  print("Current state: $state");

                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    print("Displaying search results");
                    if (state.searchResponse.posts.isEmpty) {
                      return const Center(
                        child: Text("No results found",
                            style: TextStyle(fontSize: 16)),
                      );
                    }
                    return searchResultsList(
                        searchResponse: state.searchResponse,
                        height: height,
                        width: width);
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }

                  // Default UI when search is not active
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      headings_and_view(height: height, textsize: textsize),
                      SizedBox(height: height * 0.034),
                      categoriTab(
                          width: width, height: height, textsize: textsize),
                      SizedBox(height: height * 0.038),
                      imageScroll(
                          height: height, width: width, textsize: textsize),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display search results
  Widget searchResultsList(
      {required SearchResponse searchResponse,
      required double height,
      required double width}) {
    return SizedBox(
      height: height, // Give some height to allow proper rendering
      child: ListView.builder(
        itemCount: searchResponse.posts.length,
        itemBuilder: (context, index) {
          final post = searchResponse.posts[index];
          return BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
            return ListTile(
              onTap: () {
                _focusNode.unfocus();
                context.read<SearchBloc>().add(SearchFieldUnfocused());
                _showPostPopup(context, post);
              },
              title: Text(post.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            );
          });
        },
      ),
    );
  }

  // Show popup dialog for a selected post
  void _showPostPopup(BuildContext context, Post post) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('${post.title}'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => PostDetailsPage(post: post)),
                  MaterialPageRoute(
                      builder: (context) => detailsScreen(
                            name: 'Andes Mountain',
                            location: 'South, America',
                            price: 230,
                            temperature: 16,
                            rating: 4.5,
                            imageUrl:
                                'assets/images/flutter_assement_details.png',
                            post: post,
                          )),
                );
              },
              child: Text('Open'),
            ),
          ],
        );
      },
    );
  }

  Widget userProfileHeader({required double height, required double textsize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, David 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Explore the world", style: TextStyle(color: Colors.grey)),
          ],
        ),
        CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/person.jpeg')),
      ],
    );
  }

  Widget searchBar(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return TextField(
          focusNode: _focusNode,
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
          onTap: () {
            context.read<SearchBloc>().add(SearchFieldFocused());
          },
          onEditingComplete: () {
            _focusNode.unfocus();
            context.read<SearchBloc>().add(SearchFieldUnfocused());
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffffffff),
            hintText: "   Search places",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xffD2D2D2), width: 2.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xffD2D2D2), width: 2.5),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                    scale: 1.7,
                    child: Text("|",
                        style:
                            TextStyle(color: Color(0xffD2D2D2), fontSize: 20))),
                SizedBox(width: 10),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.tune, color: Color(0xff888888)),
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  Widget headings_and_view({required double height, required double textsize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text("Popular places",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        Text("View all",
            style: TextStyle(
                color: const Color.fromARGB(255, 138, 138, 138),
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget categoriTab(
      {required double height,
      required double width,
      required double textsize}) {
    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(categories.length, (index) {
            return GestureDetector(
              onTap: () =>
                  context.read<TravelBloc>().add(ChangeCategory(index)),
              child: Container(
                decoration: BoxDecoration(
                  color: state.selectedIndex == index
                      ? Color(0xff2F2F2F)
                      : Color(0xffFBFBFB),
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: state.selectedIndex == index ? Color(0xff2F2F2F): Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.014),
                  child: Text(categories[index],
                      style: TextStyle(
                          color: state.selectedIndex == index
                              ? Colors.white
                              : Color(0xffC5C5C5))),
                ),
              ),
              // child: Chip(
              //   backgroundColor: state.se  lectedIndex == index ? Colors.black : Colors.grey[200],
              // label: Text(categories[index],
              //     style: TextStyle(
              //         color: state.selectedIndex == index ? Colors.white : Colors.black)),
              // ),
            );
          }),
        );
      },
    );
  }

  Widget imageScroll(
      {required double height,
      required double width,
      required double textsize}) {
    return Container(
      height: height * 0.5,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: places.length,
        controller: PageController(viewportFraction: 0.85),
        itemBuilder: (context, index) {
          final place = places[index];
          return Padding(
            padding: EdgeInsets.only(right: 20),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(place["image"]!,
                        fit: BoxFit.cover, height: height * 0.5),
                  ),
                ),
                Positioned(
                  top: height * 0.02,
                  right: height * 0.02,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: CircleAvatar(
                        backgroundColor: Color(0xff1D1D1D66),
                        child: Icon(Icons.favorite_border, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: height * 0.04,
                        left: width * 0.04,
                        right: width * 0.04),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff1D1D1D66)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.04,
                                top: height * 0.02,
                                bottom: height * 0.02,
                                right: width * 0.04),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(place["title"]!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: textsize * 2,
                                        fontWeight: FontWeight.w600)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              color: Colors.white70,
                                              size: height * 0.018),
                                          SizedBox(width: width * 0.015),
                                          Text(place["location"]!,
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: textsize * 1.5)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.star_border,
                                              color: Colors.white70,
                                              size: height * 0.018),
                                          SizedBox(width: width * 0.015),
                                          Text('4.8',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: textsize * 1.5)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
