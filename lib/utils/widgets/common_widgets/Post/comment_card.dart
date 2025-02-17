import 'package:connect_with/main.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  final bool isAuther;
  const CommentCard({super.key, required this.isAuther});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Column(
      children: [

        Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Container(
                width: mq.width * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.theme['secondaryColor'],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 0,
                      spreadRadius: 0.1,
                      offset: Offset(0, 0.1),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // user details and time
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                      "assets/other_images/photo.png"),
                                  backgroundColor: AppColors
                                      .theme['primaryColor']
                                      .withOpacity(0.1),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Hitesh Mori",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors
                                                    .theme['tertiaryColor'])),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        if (widget.isAuther)
                                          Container(
                                            height: 20,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: AppColors
                                                  .theme['primaryColor'],
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Author",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            )),
                                          )
                                      ],
                                    ),
                                    Text(
                                      "Application Developer",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors
                                              .theme['tertiaryColor']
                                              .withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "8h",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5)),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  size: 20,
                                )),
                          ],
                        ),
                      ],
                    ),

                    // main description
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                        )),
                        child: buildDescription(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15),
                      child: Row(
                        children: [
                          Text("Reactions ",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5))),
                          Text("0",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5))),
                          Text(" | ",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5))),
                          Text("Comment ",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5))),
                          Text("1",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.theme['tertiaryColor']
                                      .withOpacity(0.5))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // this is reply comment
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Container(
                    width: mq.width * 0.8,
                    decoration: BoxDecoration(
                      color: AppColors.theme['secondaryColor'],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 0,
                          spreadRadius: 0.1,
                          offset: Offset(0, 0.1),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // user details and time
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          "assets/other_images/photo.png"),
                                      backgroundColor: AppColors
                                          .theme['primaryColor']
                                          .withOpacity(0.1),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Hitesh Mori",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.theme[
                                                        'tertiaryColor'])),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            if (widget.isAuther)
                                              Container(
                                                height: 20,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: AppColors
                                                      .theme['primaryColor'],
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  "Author",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                )),
                                              )
                                          ],
                                        ),
                                        Text(
                                          "Application Developer",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors
                                                  .theme['tertiaryColor']
                                                  .withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "8h",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.theme['tertiaryColor']
                                          .withOpacity(0.5)),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      size: 20,
                                    )),
                              ],
                            ),
                          ],
                        ),

                        // main description
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                            )),
                            child: buildDescription(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15),
                          child: Row(
                            children: [
                              Text("0",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.theme['tertiaryColor']
                                          .withOpacity(0.5))
                              ),
                              Text(" reactions",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.theme['tertiaryColor']
                                          .withOpacity(0.5))),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildDescription(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showMore
            ? HelperFunctions.buildContent(text)
            : HelperFunctions.buildContent(
                HelperFunctions.truncateDescription(text, 300)),
        if (text.length > 300)
          TextButton(
            onPressed: () {
              setState(() {
                showMore = !showMore;
              });
            },
            child: Text(
              showMore ? 'Show Less' : 'Show More',
              style: TextStyle(color: AppColors.theme['tertiaryColor']),
            ),
          ),
      ],
    );
  }

}
