import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/link_button.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutContentOtherCompanyProfile extends StatefulWidget {
  final Organization org;
  const AboutContentOtherCompanyProfile({super.key, required this.org});

  @override
  State<AboutContentOtherCompanyProfile> createState() =>
      _AboutContentOtherCompanyProfileState();
}

class _AboutContentOtherCompanyProfileState
    extends State<AboutContentOtherCompanyProfile> {



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text14(
              text: (widget.org.about ?? "No About"),
              isBold: false,
            ),
            SizedBox(
              height: 10,
            ),
            Text16(text: "Details"),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // website
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text16(text: "Website",),
                    widget.org.website == "" ? Text14(text :"No website",isBold: false,) : LinkButton(
                      name: widget.org.website ?? "Click here!",
                      url: widget.org.website ?? "",
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                // industry
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text16(text: "Industry",),
                    widget.org.domain == "" ? Text14(text :"No website",isBold: false,) : Text14(text: widget.org.domain ?? "Industry",isBold: false,),
                  ],
                ),

                SizedBox(height: 10,),

                // company size
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text16(text: "Company Size",),
                    widget.org.companySize=="" ?  Text14(text :"0 employees",isBold: false,) : Text14(text: (widget.org.companySize ?? "Industry") + " employees",isBold: false,),
                    Text14(text: (widget.org.employees?.length.toString() ?? "0" ) + " associated members",isBold: false,),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                // headquarters
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text16(text: "Headquarters",),
                    Text14(
                      text: (widget.org.address?.cityName?.isNotEmpty == true ||
                          widget.org.address?.stateName?.isNotEmpty == true ||
                          widget.org.address?.countryName?.isNotEmpty == true)
                          ? ((widget.org.address?.cityName ?? "City") +
                          ", " +
                          (widget.org.address?.stateName ?? "State") +
                          ", " +
                          (widget.org.address?.countryName ?? "Country")) +
                          "."
                          : "No Address",
                      isBold: false,
                    ),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                // Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text16(text: "Type",),
                    widget.org.type=="" ?  Text14(text :"No Type",isBold: false,) :  Text14(
                      text: widget.org.type ?? "type",
                      isBold: false,
                    ),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                // services
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text16(
                      text: "Services",
                    ),
                    if(widget.org.services?.length==0)
                      Text14(text : "No Services added",isBold: false,),
                    if(widget.org.services?.length!=0)
                      Column(
                        children: [
                          SizedBox(height: 10,),
                          Wrap(
                            children: widget.org.services?.asMap().entries.map((entry) {
                              final index = entry.key;
                              final service = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(right: 5.0,bottom: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            service,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: AppColors.theme['primaryColor'].withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    if (index != widget.org.services!.length - 1)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: Text(
                                          "•", // Dot separator
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList() ?? [],
                          ),
                        ],
                      ),
                  ],
                ),


              ],
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
