import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/link_button.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/heading_text.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutContentCompanyProfile extends StatefulWidget {
  const AboutContentCompanyProfile({super.key});

  @override
  State<AboutContentCompanyProfile> createState() =>
      _AboutContentCompanyProfileState();
}

class _AboutContentCompanyProfileState
    extends State<AboutContentCompanyProfile> {

  @override
  void initState() {
    super.initState();
    final orgProvider = Provider.of<OrganizationProvider>(context, listen: false);
    orgProvider.initOrganization();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizationProvider>(
        builder: (context, orgProvider, child) {
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
                text: (orgProvider.organization?.about ?? "No About"),
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
                       orgProvider.organization?.website == "" ? Text14(text :"No website",isBold: false,) : LinkButton(
                         name: orgProvider.organization?.website ?? "Click here!",
                         url: orgProvider.organization?.website ?? "",
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
                      orgProvider.organization?.domain == "" ? Text14(text :"No website",isBold: false,) : Text14(text: orgProvider.organization?.domain ?? "Industry",isBold: false,),
                    ],
                  ),

                  SizedBox(height: 10,),

                  // company size
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text16(text: "Company Size",),
                      orgProvider.organization?.companySize=="" ?  Text14(text :"0 employees",isBold: false,) : Text14(text: (orgProvider.organization?.companySize ?? "Industry") + " employees",isBold: false,),
                      Text14(text: (orgProvider.organization?.employees?.length.toString() ?? "0" ) + " associated members",isBold: false,),
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
                        text: (orgProvider.organization?.address?.cityName?.isNotEmpty == true ||
                            orgProvider.organization?.address?.stateName?.isNotEmpty == true ||
                            orgProvider.organization?.address?.countryName?.isNotEmpty == true)
                            ? ((orgProvider.organization?.address?.cityName ?? "City") +
                            ", " +
                            (orgProvider.organization?.address?.stateName ?? "State") +
                            ", " +
                            (orgProvider.organization?.address?.countryName ?? "Country")) +
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
                      orgProvider.organization?.type=="" ?  Text14(text :"No Type",isBold: false,) :  Text14(
                        text: orgProvider.organization?.type ?? "type",
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
                      if(orgProvider.organization?.services?.length==0)
                        Text14(text : "No Services added",isBold: false,),
                      if(orgProvider.organization?.services?.length!=0)
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Wrap(
                            children: orgProvider.organization?.services?.asMap().entries.map((entry) {
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
                                    if (index != orgProvider.organization!.services!.length - 1)
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
    });
  }
}
