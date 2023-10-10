import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta360/bussiness_logic/providers/post_type_select_state.dart';
import 'package:insta360/interfaces/user_auth_repository.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/resources/UI/widgets/text_field.dart';
import 'package:provider/provider.dart';
import '../../../bussiness_logic/providers/profile_image_state.dart';

/// Dialog for selecting image source for profile image upload.
class ImageSourceSelectorDialog extends StatelessWidget {
  const ImageSourceSelectorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Selects source of image to be of gallery.
            GestureDetector(
              onTap: () {
                final selectImageObj = context.read<ProfileImageSelector>();
                selectImageObj.selectImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              child: const Text(
                'Gallery',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Selects source of image to be of camera.
            GestureDetector(
              onTap: () {
                final selectImageObj = context.read<ProfileImageSelector>();
                selectImageObj.selectImage(ImageSource.camera);
                Navigator.pop(context);
              },
              child: const Text(
                'Camera',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Dialog for selecting type of post (image or video).
class SelectPostTypeDialog extends StatelessWidget {
  const SelectPostTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Selects the post type of image.
            GestureDetector(
              onTap: () {
                final selectPostType = context.read<SelectPostTypeState>();
                selectPostType.selectImagePost();
                Navigator.pop(context);
              },
              child: const Text(
                'Image Post',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Selects the post type of video.
            GestureDetector(
              onTap: () {
                final selectPostType = context.read<SelectPostTypeState>();
                selectPostType.selectVideoPost();
                Navigator.pop(context);
              },
              child: const Text(
                'Video Post',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Dialog for selecting source for post upload.
class ImageSourceSelectorDialogForPost extends StatelessWidget {
  const ImageSourceSelectorDialogForPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Selects source of image to be of gallery.
            GestureDetector(
              onTap: () {
                final selectImageObj = context.read<SelectPostTypeState>();
                // Checks the type of post and select post accordingly.
                if (selectImageObj.postType == PostType.imagePost) {
                  selectImageObj.selectImage(ImageSource.gallery);
                } else {
                  selectImageObj.selectVideo(ImageSource.gallery);
                }
                Navigator.pop(context);
              },
              child: const Text(
                'Gallery',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Selects source of image to be of camera.
            GestureDetector(
              onTap: () {
                final selectImageObj = context.read<SelectPostTypeState>();
                // Checks the type of post and select post accordingly.
                if (selectImageObj.postType == PostType.imagePost) {
                  selectImageObj.selectImage(ImageSource.camera);
                } else {
                  selectImageObj.selectVideo(ImageSource.camera);
                }
                Navigator.pop(context);
              },
              child: const Text(
                'Camera',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Dialog for confirming delete action.
class DeleteCommentConfirmDialog extends StatefulWidget {
  const DeleteCommentConfirmDialog(
      {super.key,
      required this.commentId,
      required this.postId,
      required this.userId});

  final String commentId;
  final String postId;
  final String userId;

  @override
  State<DeleteCommentConfirmDialog> createState() =>
      _DeleteCommentConfirmDialogState();
}

class _DeleteCommentConfirmDialogState
    extends State<DeleteCommentConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
      height: 150,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Center(
            child: Text(
              'Delete Comment?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Container()),
          Row(
            children: [
              Expanded(child: Container()),
              // Button for delete action.
              TextButton(
                  onPressed: () async {
                    // Initializing user interaction method.
                    final userObj = UserInteractionsMethodRepository();
                    // Delete comment by comment id.
                    await userObj.deleteComment(
                        getCommentId: widget.commentId,
                        getUserId: widget.userId,
                        getPostId: widget.postId);
                    if (!mounted) return;
                    context.pop();
                  },
                  child: const Text('Delete')),
              // Button for cancel delete.
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel')),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    ));
  }
}

/// Dialog for conforming log out.
class ConfirmLogout extends StatefulWidget {
  const ConfirmLogout({super.key});

  @override
  State<ConfirmLogout> createState() => _ConfirmLogoutState();
}

class _ConfirmLogoutState extends State<ConfirmLogout> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
      height: 150,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Center(
            child: Text(
              'Are you sure, you want to log out?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Container()),
          Row(
            children: [
              Expanded(child: Container()),
              // Button for log out.
              TextButton(
                  onPressed: () async {
                    final userObj = UserAuthenticationRepository();
                    await userObj.userLogout();
                    if (!mounted) return;
                    context.pop();
                  },
                  child: const Text('Yes')),
              // Button for cancel log out.
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel')),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    ));
  }
}

/// Dialog for editing user's information.
class EditDialog extends StatefulWidget {
  const EditDialog(
      {super.key, required this.property, required this.displayProperty});

  // Gets which property to edit in database.
  final String property;

  // Gets property to display on text field as hint or label.
  final String displayProperty;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
      height: 150,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
              child: MyTextField(
                  myFieldController: textController,
                  myKeyboardInputType: TextInputType.text,
                  myHintText: widget.displayProperty,
                  myLabelText: widget.displayProperty,
                  myWidth: 200)),
          Expanded(child: Container()),
          Row(
            children: [
              Expanded(child: Container()),
              TextButton(
                  onPressed: () async {
                    // Initializing user data methods.
                    final userObj = UserDataMethodsRepository();
                    // Update information of user.
                    String result = await userObj.updateUserData(
                        userProperty: widget.property,
                        userPropertyValue: textController.text);
                    if (result == 'Success') {
                      if (!mounted) return;
                      context.pop();
                    }
                  },
                  child: const Text('Update')),
              // Button for cancel update.
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel')),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    ));
  }
}

/// Dialog for selecting image source for updating profile image.
class ImageSourceSelectorDialogForUpdateProfilePic extends StatefulWidget {
  const ImageSourceSelectorDialogForUpdateProfilePic({Key? key})
      : super(key: key);

  @override
  State<ImageSourceSelectorDialogForUpdateProfilePic> createState() =>
      _ImageSourceSelectorDialogForUpdateProfilePicState();
}

class _ImageSourceSelectorDialogForUpdateProfilePicState
    extends State<ImageSourceSelectorDialogForUpdateProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Selects source of image to be of gallery.
            GestureDetector(
              onTap: () async {
                if (!mounted) return;
                context.pop();
                final obj = UserDataMethodsRepository();
                await obj.updateProfilePic(ImageSource.gallery);
              },
              child: const Text(
                'Gallery',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Selects source of image to be of camera.
            GestureDetector(
              onTap: () async {
                if (!mounted) return;
                context.pop();
                final obj = UserDataMethodsRepository();
                await obj.updateProfilePic(ImageSource.camera);
              },
              child: const Text(
                'Camera',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
