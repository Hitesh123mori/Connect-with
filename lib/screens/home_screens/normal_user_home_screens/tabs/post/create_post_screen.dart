import 'package:connect_with/utils/helper_functions/toasts.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _key = GlobalKey<ExpandableFabState>();
  bool isButtonEnabled = false;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    descriptionController.addListener(updateButtonState);
  }

  void updateButtonState() {
      setState(() {
        isButtonEnabled = descriptionController.text.isNotEmpty;
      });

  }

  @override
  void dispose() {
    descriptionController.removeListener(updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            closeButtonBuilder: RotateFloatingActionButtonBuilder(
              child: Icon(Icons.close),
              fabSize: ExpandableFabSize.small,
              foregroundColor: AppColors.theme['secondaryColor'],
              backgroundColor: AppColors.theme['primaryColor'],
            ),
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: Icon(Icons.attach_file_outlined),
              foregroundColor: AppColors.theme['secondaryColor'],
              backgroundColor: AppColors.theme['primaryColor'],
            ),
            key: _key,
            type: ExpandableFabType.up,
            childrenAnimation: ExpandableFabAnimation.none,
            distance: 50,
            overlayStyle: ExpandableFabOverlayStyle(
              color: Colors.white.withOpacity(0.9),
            ),
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.theme['secondaryColor'],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Document',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton.small(
                    backgroundColor: AppColors.theme['primaryColor'],
                    onPressed: () {},
                    child: Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.theme['secondaryColor'],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Media',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton.small(
                    backgroundColor: AppColors.theme['primaryColor'],
                    onPressed: () {},
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.theme['secondaryColor'],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Article',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton.small(
                    backgroundColor: AppColors.theme['primaryColor'],
                    onPressed: () {},
                    child: Icon(
                      Icons.article_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.theme['secondaryColor'],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Celebrate',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton.small(
                    backgroundColor: AppColors.theme['primaryColor'],
                    onPressed: () {},
                    child: Icon(
                      Icons.celebration_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.theme['secondaryColor'],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Poll',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton.small(
                    backgroundColor: AppColors.theme['primaryColor'],
                    onPressed: () {},
                    child: Icon(
                      Icons.poll_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: AppColors.theme['secondaryColor'],
          appBar: AppBar(
            elevation: 1,
            surfaceTintColor: AppColors.theme['primaryColor'],
            title: Text(
              "Create Post",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      // Simulate a delay
                      await Future.delayed(Duration(seconds: 2));

                      print("This runs after 2 seconds");

                      setState(() {
                        isLoading = false;
                      });

                      AppToasts.InfoToast(context, "Successfully Posted");

                      Navigator.pop(context);

                    }else{
                      AppToasts.WarningToast(context, "Description cannot be empty");
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: 40,
                    width: isLoading ? 50 : 100,
                    child: !isLoading
                        ? Center(
                            child: Text(
                              "Create",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isButtonEnabled
                                    ? AppColors.theme['secondaryColor']
                                    : AppColors.theme['tertiaryColor']
                                        .withOpacity(0.5),
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))),
                    decoration: BoxDecoration(
                      color: isButtonEnabled
                          ? AppColors.theme['primaryColor']
                          : AppColors.theme['primaryColor'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
            centerTitle: true,
            backgroundColor: AppColors.theme['secondaryColor'],
            toolbarHeight: 50,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left_rounded,
                size: 35,
                color: Colors.black,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDescriptionTextField(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildDescriptionTextField() {
    return Container(
      child: Theme(
        data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
                selectionHandleColor:
                AppColors.theme['primaryColor'],
                cursorColor: AppColors.theme['primaryColor'],
                selectionColor:
                AppColors.theme['primaryColor'].withOpacity(0.3))
         ),
        child: TextFormField(
          onChanged: (_) {

          },
          controller: descriptionController,
          cursorColor: AppColors.theme['primaryColor'],
          maxLines: null,
          validator: (val) {
            if (val == null || val.isEmpty) {
              
              return "Description cannot be empty";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Start writing your description here',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}


