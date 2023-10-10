import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta360/bussiness_logic/providers/post_type_select_state.dart';
import 'package:insta360/bussiness_logic/providers/progress_indicator_status.dart';
import 'package:insta360/interfaces/post_method_repository.dart';
import 'package:insta360/resources/UI/widgets/circular_progress_bar.dart';
import 'package:insta360/resources/UI/widgets/dialogs.dart';
import 'package:insta360/resources/UI/widgets/mybutton.dart';
import 'package:insta360/resources/UI/widgets/post_view.dart';
import 'package:panorama/panorama.dart';
import 'package:provider/provider.dart';

/// Defines screen for adding new post.
class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  // Controller for post caption.
  late TextEditingController captionController;

  @override
  void initState() {
    super.initState();
    // Initializing controller.
    captionController = TextEditingController();
    // Initializing select post type state provider.
    final selectPostObj = context.read<SelectPostTypeState>();
    // Setting the initial post to null;
    selectPostObj.post = null;
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(width: 0.3, color: Colors.white),
                  bottom: BorderSide(width: 0.3, color: Colors.white))),
          width: double.infinity,
          // Keeping height of post to be 60% of screen height.
          height: height * 0.6,
          // Using row to centralize the post view horizontally.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // Keeping height of post to be 60% of screen height.
                height: height * 0.6,
                child: AspectRatio(
                  aspectRatio: 0.6,
                  // 3D images and videos render outside the boundary of container or sized box,
                  // so for that we have clipped it.
                  child: ClipPath(
                    clipper: PostClipper(),
                    // Consuming select post type state provider.
                    child: Consumer<SelectPostTypeState>(
                      builder: (context, obj, __) {
                        // Checks if post is null.
                        return obj.post != null
                            // If post is not null, then it will render 3D image in Panorama widget if post type is image
                            // or it will render 3D video in VideoPost widget if post type is video.
                            ? obj.postType == PostType.imagePost
                                ? Panorama(
                                    child: Image.memory(obj.postBytes!),
                                  )
                                : VideoPost(postUrl: obj.post!.path)
                            // If post is null, then it wll render container displaying a text to select post.
                            : Container(
                                color: Colors.white24,
                                child: const Center(
                                  child: Text('Select Post'),
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Returns dialog fpr selecting post type.
                  return const SelectPostTypeDialog();
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<SelectPostTypeState>(
                builder: (context, obj, __) {
                  // Display current post type state.
                  return Text(
                    obj.postType == PostType.imagePost
                        ? 'Image Post'
                        : 'Video Post',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  );
                },
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: MyButton(
              buttonText: 'Select Post',
              onButtonPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // Returns dialog for selecting source of post file.
                      return const ImageSourceSelectorDialogForPost();
                    });
              }),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          // Text field for caption.
          child: TextField(
            controller: captionController,
            maxLines: 3,
            decoration:
                const InputDecoration(hintText: 'Add Caption', filled: true),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          // Todo
          child: MyButton(
              buttonText: 'Post',
              buttonHeight: 40,
              onButtonPressed: () async {
                final postObj = PostMethodsRepository();
                final selectPostObj = context.read<SelectPostTypeState>();
                if (selectPostObj.postType == PostType.imagePost) {
                  String result = await postObj.addPost(
                      post: selectPostObj.postBytes!,
                      getCaption: captionController.text,
                      type: 'img',
                      context: context);
                  if (!mounted) return;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CircularProgressBar();
                      });
                  if (result == 'Success' || result == 'Error') {
                    context.pop();
                    final obj = context.read<ProgressIndicatorStatus>();
                    obj.reset();
                  }
                } else if (selectPostObj.postType == PostType.videoPost) {
                  String result = await postObj.addPost(
                      post: selectPostObj.postBytes!,
                      getCaption: captionController.text,
                      type: 'vid',
                      context: context);
                  if (!mounted) return;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CircularProgressBar();
                      });
                  if (result == 'Success' || result == 'Error') {
                    context.pop();
                    final obj = context.read<ProgressIndicatorStatus>();
                    obj.reset();
                  }
                }
              }),
        ),
        const SizedBox(
          height: 70,
        ),
      ],
    );
  }
}
