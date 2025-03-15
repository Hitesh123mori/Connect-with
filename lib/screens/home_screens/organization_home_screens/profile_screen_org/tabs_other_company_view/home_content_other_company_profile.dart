import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/link_button.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeContentOtherCompanyProfile extends StatefulWidget {
  final Organization org ;
  const HomeContentOtherCompanyProfile({super.key, required this.org});

  @override
  State<HomeContentOtherCompanyProfile> createState() =>
      _HomeContentOtherCompanyProfileState();
}

class _HomeContentOtherCompanyProfileState extends State<HomeContentOtherCompanyProfile> {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(heading: "Overview"),
            SizedBox(
              height: 10,
            ),
            Text14(
              text: (widget.org.about ?? "No Latest News"),
              isBold: false,
            ),
            SizedBox(
              height: 10,
            ),
            if (widget.org.latestNews != "")
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.newspaper_outlined,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        LinkButton(
                            name: "Click Here",
                            url: widget.org.latestNews ?? ""),
                      ],
                    ),
                  ]),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
