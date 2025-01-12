import 'package:connect_with/main.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/other_widgets/image_uploader_container.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_feild_1.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCompanyProfile extends StatefulWidget {
  const EditCompanyProfile({super.key});

  @override
  State<EditCompanyProfile> createState() => _EditCompanyProfileState();
}

class _EditCompanyProfileState extends State<EditCompanyProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? companyName;
  String? about;
  String? domain;
  String? type;
  String? csize;
  String? website;
  String? _countryName;
  String? _stateName;
  String? _cityName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Consumer<OrganizationProvider>(
        builder: (context, orgProvider, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: AppColors.theme['backgroundColor'],
            appBar: AppBar(
              title: Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.theme['primaryColor'],
              toolbarHeight: 50,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Basic Information
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.theme['secondaryColor'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(child: Text18(text: "Basic Information")),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              // name field
                              Text16(
                                text: "Name",
                                isBold: true,
                              ),
                              TextFeild1(
                                hintText: "Enter Name",
                                isNumber: false,
                                prefixicon: Icon(Icons.text_format_outlined),
                                obsecuretext: false,
                                initialText: orgProvider.organization?.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Name cannot be empty";
                                  }
                                  return null;
                                },
                                onSaved: (value) => companyName = value,
                              ),
                              SizedBox(height: 10),

                              // About field
                              Text16(
                                text: "About",
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.theme['backgroundColor'],
                                    border: Border.all(
                                        color:
                                            AppColors.theme['primaryColor'])),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    cursorColor:
                                        AppColors.theme['primaryColor'],
                                    obscureText: false,
                                    initialValue:
                                        orgProvider.organization?.about,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText:
                                            'Write job description here...',
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'description is required';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => about = value,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              // domain field
                              Text16(text: "Domain"),
                              TextFeild1(
                                hintText: "Enter domain",
                                isNumber: false,
                                prefixicon: Icon(Icons.text_format_outlined),
                                obsecuretext: false,
                                initialText: orgProvider.organization?.domain,
                                onSaved: (value) => domain = value,
                              ),
                              SizedBox(height: 10),

                              //  Type
                              Text18(text: "Company Type"),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.theme['backgroundColor'],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.theme['primaryColor']!,
                                    width: 1.0,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<String>(
                                  value: type,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  hint: Text(
                                    'Select Experience Type',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.theme['primaryColor']),
                                  ),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: AppColors.theme['primaryColor']),
                                  dropdownColor:
                                      AppColors.theme['backgroundColor'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.theme['primaryColor']),
                                  items: [
                                    'Public Company',
                                    'Private Company',
                                    'Start Up',
                                    'Non-Profit Organization',
                                    'Government Organization'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      type = newValue;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10),

                              // company size
                              Text16(text: "Company Size"),
                              TextFeild1(
                                hintText: "Enter Company Size",
                                isNumber: false,
                                prefixicon: Icon(Icons.text_format_outlined),
                                obsecuretext: false,
                                initialText:
                                    orgProvider.organization?.companySize,
                                onSaved: (value) => csize = value,
                              ),
                              SizedBox(height: 10),

                              // website field
                              Text16(text: "Company Website"),
                              TextFeild1(
                                hintText: "Enter Website Size",
                                isNumber: false,
                                prefixicon: Icon(Icons.text_format_outlined),
                                obsecuretext: false,
                                initialText: orgProvider.organization?.website,
                                onSaved: (value) => website = value,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Address field
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.theme['secondaryColor'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: Text18(text: "Address Information")),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              // city name
                              Text16(
                                text: "City Name",
                              ),
                              TextFeild1(
                                hintText: "Enter CityName",
                                isNumber: false,
                                prefixicon: Icon(Icons.text_format_outlined),
                                obsecuretext: false,
                                initialText:
                                    orgProvider.organization?.address?.cityName,
                                onSaved: (value) => _cityName = value,
                              ),
                              SizedBox(height: 10),

                              // state name
                              Text16(text: "State Name"),
                              TextFeild1(
                                hintText: "Enter StateName",
                                isNumber: false,
                                prefixicon: Icon(Icons.text_format_outlined),
                                obsecuretext: false,
                                initialText: orgProvider
                                    .organization?.address?.stateName,
                                onSaved: (value) => _stateName = value,
                              ),
                              SizedBox(height: 10),

                              // country name
                              Text16(text: "Country Name"),
                              TextFeild1(
                                hintText: "Enter CountryName",
                                isNumber: false,
                                prefixicon: Icon(Icons.text_format_outlined),
                                obsecuretext: false,
                                initialText: orgProvider
                                    .organization?.address?.countryName,
                                onSaved: (value) => _countryName = value,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // image picker
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.theme['secondaryColor'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child:
                                      Text18(text: "Logo and Cover Picture")),
                              Divider(
                                color: AppColors.theme['primaryColor'],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text16(text: "Logo Image"),
                              SizedBox(
                                height: 10,
                              ),
                              ImageUploaderContainer(
                                  parheight: 100,
                                  parwidth: mq.width * 1,
                                  childheight: 80,
                                  childwidth: mq.width * 0.6),
                              SizedBox(
                                height: 10,
                              ),
                              Text16(text: "Logo Image"),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: ImageUploaderContainer(
                                      parheight: 100,
                                      parwidth: mq.width * 0.5,
                                      childheight: 80,
                                      childwidth: mq.width * 0.3)),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
