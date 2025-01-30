import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/core/uttils/responsiveSizeHelper.dart';

import 'dart:math' as math;
import 'package:task_amit/data/search_model.dart';
import 'package:task_amit/logic/favorit_bloc.dart';

class detailsScreen extends StatelessWidget {
  final String name;
  final String location;
  final double price;
  final double temperature;
  final double rating;
  final String imageUrl;
  final Post post;

  detailsScreen({
    required this.name,
    required this.location,
    required this.price,
    required this.temperature,
    required this.rating,
    required this.imageUrl,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textsize = SizeConfig.textSize;
    double iconsize = height * 0.02;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height * 0.05),
                Container(
                  height: height * 0.5,
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.045),
                        child: Container(
                          height: height * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.only(top: height * 0.09),
                              child: Transform.scale(
                                scale: 1.7,
                                child: Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: width * 0.08,
                        top: height * 0.02,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff1D1D1D66),
                            // borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 0.02),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: width * 0.085,
                        top: height * 0.02,
                        child: BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, state) {
                            bool isFavorite = false;
                            if (state is FavoritesLoaded) {
                              isFavorite = state.favoritePosts
                                  .any((savedPost) => savedPost.id == post.id);
                            }

                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff1D1D1D66),
                                // borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  color: isFavorite ? Colors.red : Colors.white,
                                ),
                                onPressed: () {
                                  context
                                      .read<FavoriteBloc>()
                                      .add(ToggleFavorite(post));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: height * 0.04,
                              left: width * 0.1,
                              right: width * 0.1),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Andes Mountain',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: textsize * 2.3,
                                                  fontWeight: FontWeight.w600)),
                                          Text('Price',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: textsize * 1.5,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
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
                                                    size: height * 0.023),
                                                SizedBox(width: width * 0.016),
                                                Text('South, America',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize:
                                                            textsize * 1.8)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('\$',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            217, 121, 121, 121),
                                                        fontSize:
                                                            textsize * 1.7)),
                                                Text('230',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize:
                                                            textsize * 2.3)),
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
                ),
                SizedBox(height: height * 0.04),
                // Text(
                //   name,
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // Text(
                //   location,
                //   style: TextStyle(fontSize: 16, color: Colors.grey),
                // ),
                headings_and_view(
                    height: height, width: width, textsize: textsize),
                SizedBox(height: height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Color(0xffEDEDED),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.005),
                                child: Icon(Icons.access_time,
                                    size: iconsize, color: Color(0xff3F3F3F)),
                              )),
                          SizedBox(width: width * 0.01),
                          Text('${post.userId} hours'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Color(0xffEDEDED),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.005),
                                child: Icon(Icons.cloud,
                                    size: iconsize, color: Color(0xff3F3F3F)),
                              )),
                          SizedBox(width: width * 0.01),
                          Text('${temperature}°C'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Color(0xffEDEDED),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.005),
                                child: Icon(Icons.star_border,
                                    size: iconsize, color: Color(0xff3F3F3F)),
                              )),
                          SizedBox(width: width * 0.01),
                          Text('${rating}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    post.body,
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Container(
                height: height * 0.07,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff1B1B1B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Transform.rotate(
                      angle: -math.pi /
                          4, // Negative for counter-clockwise rotation, pi/4 = 45 degrees
                      child: Icon(Icons.send_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget headings_and_view(
      {required double height,
      required double textsize,
      required double width}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text("Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          Text("Details",
              style: TextStyle(
                  color: const Color.fromARGB(255, 138, 138, 138),
                  fontWeight: FontWeight.w700)),
          SizedBox(width: width * 0.2),
        ],
      ),
    );
  }
}
