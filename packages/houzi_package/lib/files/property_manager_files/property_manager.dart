import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:background_downloader/background_downloader.dart';

import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';


/// A class that is used to 'Add' a property as well as notify about the
/// property uploading. After user provide all the necessary information, it
/// got saved in the storage.
///
///
/// This class has a method [uploadProperty] which uploads the property or
/// properties in recursive manner. It perform following steps to 'add' the
/// property:
///
/// 1. It reads the required data to 'add' property from the storage.
///
/// 2. If storage is not null or not empty, it reads the 'List' of
///    'to-be-uploaded' properties.
///
/// 3. The property data is always taken from the 0th index of the property
///    information list.
///
/// 4. Before uploading the property data to the [API], it always checks for
///    any pending image that is yet to be uploaded.
///
/// 5. Each image contains its uploading status, if there is any image that is
///    still not uploaded, it is uploaded and the
///    information about uploaded image id etc. is updated in image itself and
///    the property information as well as in the storage (so that in worst-case scenario
///    (App crash), we do not have to upload the 'pending' image again).
///
/// 6. If all the images are uploaded or there are no pending images, then the
///    property data in form of 'Form Data', is POSTED to [API] so that
///    property could be uploaded.
///
/// 7. If property uploads successfully, then the property data is removed from
///    storage list and the 'Upload Property' method is called again.

class PropertyManager with ChangeNotifier {
  /// static PropertyManager _instance;
  /// static PropertyManager getState() {
  ///   if (_instance == null) {
  ///     _instance = PropertyManager._internal();
  ///  }
  ///
  ///   return _instance;
  /// }
  static PropertyManager? _propertyManager;
  factory PropertyManager() {
    // if (_propertyManager == null) {
    //   _propertyManager = PropertyManager._internal();
    // }
    _propertyManager ??= PropertyManager._internal();
    return _propertyManager!;
  }

  String imageUploadingLabel = "Uploading";

  final PropertyBloc _propertyBloc = PropertyBloc();

  List _tasksIdsList = [];

  bool _isPropertyUploaderFree = true;
  bool get isPropertyUploaderFree => _isPropertyUploaderFree;

  int? _uploadedPropertyId;
  int? _totalProgress;

  set uploadedPropertyId(int? value) {
    _uploadedPropertyId = value;
  }

  set setTotalProgress(int? value) {
    _totalProgress = value;
  }

  int? get uploadedPropertyId => _uploadedPropertyId;
  int? get getTotalProgress => _totalProgress;

  final uploader = FileDownloader();

  ///
  /// Initializer of Class Network Manager
  ///
  PropertyManager._internal(){
    // Needed so that plugin communication works.
    WidgetsFlutterBinding.ensureInitialized();
    ///
    /// Listener for Flutter Uploader:
    ///
    ///
    // configure notification for all tasks
    uploader.configureNotification(
        running: TaskNotification('Uploading', '{displayName}'),
        complete: TaskNotification('Upload Complete', ''),
        error: TaskNotification('Error', 'Failed to Upload {filename}'),
        progressBar: true
    );

    final subscription = uploader.updates.listen((update) {
      switch(update) {
        case TaskProgressUpdate():
          print('Progress update for ${update.task.taskId} with progress ${update.progress}');
        case TaskStatusUpdate():
          if (kDebugMode && enableUploadPropertyLogs) {
            print('Status update for ${update.task.taskId} with status ${update.status}');
            // print("Uploader Listener() is Called...");
          }


          String taskId = update.task.taskId;
          // String taskId = uploadTaskResponse.taskId;
          if (kDebugMode && enableUploadPropertyLogs) {
            print("Task Id: $taskId");
            print("task status is: ${update.status}.");
          }

          if (update.status != TaskStatus.complete) {
            return;
          }
          if (kDebugMode && enableUploadPropertyLogs) {
            print("Tasks Ids List from Hive Storage...");
          }
          _tasksIdsList = HiveStorageManager.readTasksIdsList() ?? [];

          if (kDebugMode && enableUploadPropertyLogs) {
            print("Tasks id list: $_tasksIdsList");
          }

          if(_tasksIdsList.isNotEmpty && _tasksIdsList.contains(taskId)){
            if (kDebugMode && enableUploadPropertyLogs) {
              print("Task id already exists...");
            }
            return;
          }

          if (kDebugMode && enableUploadPropertyLogs) {
            print("Storing Task id in Hive Storage...");
          }
          _tasksIdsList.add(taskId);
          HiveStorageManager.storeTasksIdsList(_tasksIdsList);

          if (kDebugMode && enableUploadPropertyLogs) {
            print("Reading Properties List from Hive Storage...");
          }
          List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertiesDataMaps() ?? [];
          if (_propertyDataMapsList.isEmpty) {
            if (kDebugMode && enableUploadPropertyLogs) {
              print("List is Empty...");
            }
            return;
          }
          if(_propertyDataMapsList.isNotEmpty){
            if (update.responseStatusCode == 200 && update.responseBody != null) {

              if (kDebugMode && enableUploadPropertyLogs) {
                print("List is not Empty...");
              }

              Map map = jsonDecode(update.responseBody!);
              Map<String, dynamic> _propertyDataMap = UtilityMethods.convertMap(_propertyDataMapsList[0]);
              ///
              /// if property uploading is already in Progress, then there is no need to do anything
              if(_propertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] == ADD_PROPERTY_UPLOAD_STATUS_IN_PROGRESS){
                if (kDebugMode && enableUploadPropertyLogs) {
                  print("Property Upload Status: InProgress...");
                }
                return;
              }
              String attachmentId = "";
              String imageUrl = "";

              if(map.containsKey(ATTACHMENT_ID) && map[ATTACHMENT_ID] != null){
                attachmentId = map[ATTACHMENT_ID].toString();
              }
              if(map.containsKey(FULL_IMAGE) && map[FULL_IMAGE] != null){
                imageUrl = map[FULL_IMAGE];
              }

              if (kDebugMode && enableUploadPropertyLogs) {
                print("Uploaded Image Attachment Id: $attachmentId");
                print("Uploaded Image url: $imageUrl");
              }

              int totalFloorPlansPendingImages = 0;
              int totalPendingImages = 0;

              if(_propertyDataMap[ADD_PROPERTY_FLOOR_PLANS] != null && _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS].isNotEmpty){
                // List<Map<String, dynamic>> floorPlansList = _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS];
                List<dynamic> floorPlansList = _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS] ?? [];
                // print("Floor Plans List Before: $floorPlansList");
                for (int i = 0; i < floorPlansList.length; i++) {
                  Map<String, dynamic> tempFloorPlanMap = UtilityMethods.convertMap(floorPlansList[i]);
                  if(tempFloorPlanMap.containsKey(favePlanPendingImage) &&
                      tempFloorPlanMap[favePlanPendingImage] != null &&
                      tempFloorPlanMap[favePlanPendingImage].isNotEmpty){
                    Map<String, dynamic> _imageMap = UtilityMethods.convertMap(floorPlansList[i][favePlanPendingImage]);
                    String? imageTaskId = _imageMap[IMAGE_TASK_ID];
                    if (imageTaskId != null && taskId == imageTaskId) {
                      if (kDebugMode && enableUploadPropertyLogs) {
                        print("Uploaded Floor Plan Image Task Id Matched..."
                            "\nFloor Plan TaskId: $taskId"
                            "\nFloor Plan ImageTaskId: $imageTaskId"
                        );
                      }
                      _imageMap[PROPERTY_MEDIA_IMAGE_STATUS] = UPLOADED;
                      _imageMap[ATTACHMENT_ID] = attachmentId;
                      floorPlansList[i][favePlanImage] = imageUrl;
                      if (kDebugMode && enableUploadPropertyLogs) {
                        print("Floor Plan Image Status Changed to UPLOADED");
                      }
                    }

                    ///Necessary step to update the original array
                    floorPlansList[i][favePlanPendingImage] = _imageMap;
                  }
                }
                ///Necessary step to update the original map
                _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS] = floorPlansList;

                if (kDebugMode && enableUploadPropertyLogs) {
                  print("Floor Plans List After: $floorPlansList");
                }

                /// Find out Total Floor Plans Pending Images
                // for(var item in floorPlansList){
                //   if(item[favePlanPendingImage][PROPERTY_MEDIA_IMAGE_STATUS] == PENDING){
                //     totalFloorPlansPendingImages++;
                //   }
                // }

                for(var item in floorPlansList){
                  Map<String, dynamic> tempFloorPlansMap = UtilityMethods.convertMap(item);
                  if(tempFloorPlansMap.containsKey(favePlanPendingImage) &&
                      tempFloorPlansMap[favePlanPendingImage] != null &&
                      tempFloorPlansMap[favePlanPendingImage].isNotEmpty){
                    if(tempFloorPlansMap[favePlanPendingImage][PROPERTY_MEDIA_IMAGE_STATUS] != null
                        && tempFloorPlansMap[favePlanPendingImage][PROPERTY_MEDIA_IMAGE_STATUS] == PENDING){
                      totalFloorPlansPendingImages++;
                    }
                  }
                }
                if (kDebugMode && enableUploadPropertyLogs) {
                  print("Total Floor Plans Pending Images: $totalFloorPlansPendingImages");
                }

                if(totalFloorPlansPendingImages == 0){
                  _totalProgress = 40;

                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Total Progress: $_totalProgress");
                  }

                  notifyListeners();

                  /// Remove all Fave Plan Pending Image objects
                  for(var item in floorPlansList){
                    item.remove(favePlanPendingImage);
                  }
                }
              }

              ///
              /// Update the image status and set the attachment id we got from server.
              ///
              List<dynamic> _imageList = _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] ?? [];
              for (int i = 0; i < _imageList.length; i++) {
                Map<String, dynamic> _imageMap = UtilityMethods.convertMap(_imageList[i]);
                String? imageTaskId = _imageMap[IMAGE_TASK_ID];
                if (imageTaskId != null && taskId == imageTaskId) {
                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Uploaded Image Task Id Matched..."
                        "\nTaskId: $taskId"
                        "\nImageTaskId: $imageTaskId"
                    );
                  }
                  _imageMap[PROPERTY_MEDIA_IMAGE_STATUS] = UPLOADED;
                  _imageMap[ATTACHMENT_ID] = attachmentId;
                  // print("Image Status Changed to UPLOADED");
                }
                ///Necessary step to update the original array
                _imageList[i] = _imageMap;
              } // for loop

              ///Necessary step to update the original map
              _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageList;

              /// Find the total pending images.
              for (int j = 0; j < _imageList.length; j++) {
                Map<String, dynamic> _imageMap = UtilityMethods.convertMap(_imageList[j]);
                String? imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
                if (imageStatus != null && imageStatus == PENDING) {
                  totalPendingImages++;
                }
              }
              if (kDebugMode && enableUploadPropertyLogs) {
                print("Total Pending Images: $totalPendingImages");
              }
              ///
              /// Check if all the images have been uploaded.
              ///
              if (totalPendingImages == 0 && totalFloorPlansPendingImages == 0) {
                _totalProgress = 80;

                if (kDebugMode && enableUploadPropertyLogs) {
                  print("Total Progress: $_totalProgress");
                }

                notifyListeners();

                if (kDebugMode && enableUploadPropertyLogs) {
                  print("No Pending Images...");
                  print("All the images have been uploaded, \nNow upload property...");
                }

                String? _featuredImageLocalId = _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID];

                List<String> _propertyImageIdsList = [];
                for (int j = 0; j < _imageList.length; j++) {
                  Map<String, dynamic> _imageMap = UtilityMethods.convertMap(_imageList[j]);
                  String? imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
                  String? attachmentId = (_imageMap[ATTACHMENT_ID] != null)
                      ? _imageMap[ATTACHMENT_ID].toString()
                      : null;

                  if ((imageStatus != null) && (imageStatus == UPLOADED) && (attachmentId != null)) {
                    _propertyImageIdsList.add(attachmentId);
                  }
                  ///
                  /// if uploaded image has the same local_id as of featured image local_id then
                  /// set the Uploaded id to Property Featured Image Id:
                  ///
                  if (_featuredImageLocalId != null && attachmentId != null &&
                      _imageMap[PROPERTY_MEDIA_IMAGE_ID] != null &&
                      _featuredImageLocalId == _imageMap[PROPERTY_MEDIA_IMAGE_ID]) {
                    _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_ID] = attachmentId;
                    if (kDebugMode && enableUploadPropertyLogs) {
                      print("Setting Featured Image Attachment Id...\nFeatured Image Attachment Id: $attachmentId");
                    }
                  }
                }
                ///
                /// if already have image ids in property map, just append these newly updated list.
                /// otherwise create new.
                ///
                if (_propertyDataMap.containsKey(ADD_PROPERTY_IMAGE_IDS)) {
                  List<dynamic> exPropertyImageIdsList = _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] ?? [];
                  if(exPropertyImageIdsList.isNotEmpty){
                    exPropertyImageIdsList.addAll(_propertyImageIdsList);
                    _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = exPropertyImageIdsList;
                  }
                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Appending Images Attachment Ids List to Property Data Map...");
                  }
                } else {
                  if(_propertyImageIdsList.isNotEmpty) {
                    _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = _propertyImageIdsList;
                  }
                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Adding Images Attachment Ids List to Property Data Map...");
                  }
                }
                ///
                /// if property upload Status is "Pending" then upload it
                if (_propertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] == ADD_PROPERTY_UPLOAD_STATUS_PENDING) {
                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Property Upload Status: Pending...");
                  }
                  ///
                  ///Going to upload this property, store its status as 'in_progress'
                  _propertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] = ADD_PROPERTY_UPLOAD_STATUS_IN_PROGRESS;
                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Changing Property Upload Status to In Progress...");
                  }
                  ///
                  ///Necessary step to update the original map
                  _propertyDataMapsList[0] = _propertyDataMap;
                  ///
                  /// Update the data in Storage:
                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Updating Data in Storage...");
                  }
                  storeData(_propertyDataMapsList);

                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Resetting Task ids List in Hive Storage...");
                  }
                  _tasksIdsList.clear();
                  HiveStorageManager.storeTasksIdsList(_tasksIdsList);

                  if (kDebugMode && enableUploadPropertyLogs) {
                    print("Uploading Property Via Dio...");
                  }
                  uploadPropertyViaDio(_propertyDataMap);
                }
              } else {
                if (kDebugMode && enableUploadPropertyLogs) {
                  print("There are still some Pending Images...");
                }
                ///Necessary step to update the original map
                _propertyDataMapsList[0] = _propertyDataMap;
                ///
                /// Update the data in Shared Preferences:
                if (kDebugMode && enableUploadPropertyLogs) {
                  print("Updating Data in Storage...");
                }
                storeData(_propertyDataMapsList);
              }
            }

          }
      }
    });
  }

  uploadProperty()  async {
    if (kDebugMode && enableUploadPropertyLogs) {
      print("uploadProperty() is called...");
    }
    ///
    /// Check for any pending properties in Storage:
    ///
    print("Checking for any pending properties in Storage...");
    List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertiesDataMaps() ?? [];
    ///
    /// If found any pending property, upload pending properties using Recursion.
    /// Base case: when there is no property left in list.
    ///
    if (_propertyDataMapsList.isEmpty) {
      print('PropertyManager: No Property to be Uploaded...');
      _isPropertyUploaderFree = true;
      WidgetsBinding.instance.addPostFrameCallback((_){
        notifyListeners();
      });
      return;
    }

    // if (_propertyDataMapsList.isEmpty) {
    //   _isPropertyUploaderFree = true;
    //   notifyListeners();
    //   print('PropertyManager: All Properties Uploaded...');
    //   return;
    // }
    ///
    /// Notify the observers that property / properties are being uploaded.
    ///
    _isPropertyUploaderFree = false;
    _totalProgress = 0;
    if (kDebugMode && enableUploadPropertyLogs) {
      print("Total Progress: $_totalProgress");
    }
    notifyListeners();

    print('PropertyManager: Found some properties...');

    Map<String, dynamic> _propertyDataMap = UtilityMethods.convertMap(_propertyDataMapsList[0]);
    if (kDebugMode && enableUploadPropertyLogs) {
      print("Property Data Map: $_propertyDataMap");
    }

    if (_propertyDataMap.isNotEmpty){
      bool noFloorPlansPendingImage = true;
      bool noPendingPropertyImage = true;

      /// First check for pending Floor Plan/Plans Image/Images
      List<dynamic> floorPlansList =  _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS] ?? [];
      String? imageNonce = _propertyDataMap[ADD_PROPERTY_IMAGE_NONCE] ?? null;

      ApiResponse? nonceResponse = await _propertyBloc.fetchAddImageNonceResponse();
      if (nonceResponse.success) {
        imageNonce = nonceResponse.result;
      }

      if(floorPlansList.isNotEmpty){
        int totalFloorPlansPendingImages = 0;
        int uploadingFloorPlansPendingImagesCount = 0;

        // Find out Total Floor Plans Pending Images
        for(var item in floorPlansList){
          Map<String, dynamic> tempFloorPlansMap = UtilityMethods.convertMap(item);
          // print("Data Type of Floor Plan Item: ${tempFloorPlansMap.runtimeType}");
          // print("Floor Plan Item: ${tempFloorPlansMap}");
          if(tempFloorPlansMap.isNotEmpty &&
              tempFloorPlansMap.containsKey(favePlanPendingImage) &&
              tempFloorPlansMap[favePlanPendingImage] != null &&
              tempFloorPlansMap[favePlanPendingImage].isNotEmpty){
            if(tempFloorPlansMap[favePlanPendingImage][PROPERTY_MEDIA_IMAGE_STATUS] != null &&
                tempFloorPlansMap[favePlanPendingImage][PROPERTY_MEDIA_IMAGE_STATUS] == PENDING){
              totalFloorPlansPendingImages++;
            }
          }
        }

        // print("Total Floor Plans Pending Images (Uploader): $totalFloorPlansPendingImages");

        /// Clear All previous Tasks from Uploader Queue
        if(totalFloorPlansPendingImages > 0){
          if (kDebugMode && enableUploadPropertyLogs) {
            print("FP: Clearing All previous Tasks from Uploader Queue...");
          }
          uploader.taskQueues.clear();

          for (int i = 0; i < floorPlansList.length; i++) {
            Map<String, dynamic> _imageMap = UtilityMethods.convertMap(floorPlansList[i][favePlanPendingImage]);

            if (kDebugMode && enableUploadPropertyLogs) {
              print("_imageMap from Floor Plan List (Uploader): $_imageMap");
            }

            String? imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];

            if (imageStatus != null && imageStatus == PENDING) {
              noFloorPlansPendingImage = false;
              uploadingFloorPlansPendingImagesCount++;

              /// if imageMap already has task id then remove it.
              if(_imageMap.containsKey(IMAGE_TASK_ID)){
                _imageMap.remove(IMAGE_TASK_ID);
              }

              final String? imagePath = _imageMap[PROPERTY_MEDIA_IMAGE_PATH];
              final String imageName = _imageMap[PROPERTY_MEDIA_IMAGE_NAME] ?? "";

              if (imagePath != null) {
                final task = UploadTask(
                  url: '${_propertyBloc.provideSavePropertyImagesApi()}',
                  filename: imageName,
                  headers: {"Authorization": "Bearer ${HiveStorageManager.getUserToken()}"},
                  fields: {"user_id": '${HiveStorageManager.getUserId()}', kAddImageNonceVariable : imageNonce!},
                  fileField: "property_upload_file",
                  httpRequestMethod: 'POST',
                  updates: Updates.statusAndProgress,
                  displayName: '$imageUploadingLabel $uploadingFloorPlansPendingImagesCount/$totalFloorPlansPendingImages',
                );

                // var taskId = await FlutterUploader().enqueue(
                //   MultipartFormDataUpload(
                //     url: '${_propertyBloc.provideSavePropertyImagesApi()}',
                //     files: [
                //       FileItem(
                //         path: imagePath,
                //         field: "property_upload_file",
                //       ),
                //     ],
                //     headers: {"Authorization": "Bearer ${HiveStorageManager.getUserToken()}"},
                //     method: UploadMethod.POST,
                //     data: {"user_id": '${HiveStorageManager.getUserId()}', kAddImageNonceVariable : imageNonce!},
                //     tag: '$imageUploadingLabel $uploadingFloorPlansPendingImagesCount/$totalFloorPlansPendingImages',
                //   ),
                // );

                uploader.enqueue(task);
                var taskId = task.taskId;

                if (kDebugMode && enableUploadPropertyLogs) {
                  print("Task[$i]Id: $taskId");
                }

                ///Save taskId to keep track and assign attachment_id to relevant image record.
                ///when this image uploads.
                _imageMap[IMAGE_TASK_ID] = taskId;
              }

              ///Assign back this map, to keep it updated in the list
              floorPlansList[i][favePlanPendingImage]  = _imageMap;
            }
          }

          if (kDebugMode && enableUploadPropertyLogs) {
            print("Floor Plans ImagesList with Assigned TaskIds: $floorPlansList");
          }

          ///Assign back the list in property map, to keep it updated with status.
          if (kDebugMode && enableUploadPropertyLogs) {
            print("Adding Floor Plans ImagesList with Assigned TaskIds to Property Map");
          }
          _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS] = floorPlansList;

          ///Assign back this particular property map to 0 index.
          _propertyDataMapsList[0] = _propertyDataMap;

          ///store whole map so we know the proper task id, even after application killed.
          if (kDebugMode && enableUploadPropertyLogs) {
            print("Updating Property Map List in Storage...");
          }
          storeData(_propertyDataMapsList);
        }

      }

      _totalProgress = 20;

      if (kDebugMode && enableUploadPropertyLogs) {
        print("Total Progress: $_totalProgress");
      }

      notifyListeners();


      ///
      /// Check for pending property images:
      ///
      if (kDebugMode && enableUploadPropertyLogs) {
        print("Checking for pending property images...");
      }
      List<dynamic> _imageList = _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] ?? [];

      int totalPendingImages = 0;

      if(_imageList.isNotEmpty){
        int uploadingImageCount = 0;

        //find total pending images.
        for (int j = 0; j < _imageList.length; j++) {
          Map<String, dynamic> _imageMap = UtilityMethods.convertMap(_imageList[j]);
          String? imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
          if (imageStatus != null && imageStatus == PENDING) {
            totalPendingImages++;
          }
        }
        if (kDebugMode && enableUploadPropertyLogs) {
          // print("Total pending images: $totalPendingImages");
        }


        if(noFloorPlansPendingImage){
          /// Clear All previous Tasks from Uploader Queue
          if(totalPendingImages > 0){
            if (kDebugMode && enableUploadPropertyLogs) {
              print("Clearing All previous Tasks from Uploader Queue...");
            }
            uploader.taskQueues.clear();
          }
        }


        for (int j = 0; j < _imageList.length; j++) {
          Map<String, dynamic> _imageMap = UtilityMethods.convertMap(_imageList[j]);
          String? imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];

          if (imageStatus != null && imageStatus == PENDING) {
            noPendingPropertyImage = false;
            uploadingImageCount++;

            /// if imageMap already has task id then remove it.
            if(_imageMap.containsKey(IMAGE_TASK_ID)){
              _imageMap.remove(IMAGE_TASK_ID);
            }

            final String? imagePath = _imageMap[PROPERTY_MEDIA_IMAGE_PATH];
            final String imageName = _imageMap[PROPERTY_MEDIA_IMAGE_NAME] ?? "";

            if (imagePath != null) {
              final task = UploadTask(
                url: '${_propertyBloc.provideSavePropertyImagesApi()}',
                filename: imageName,
                headers: {"Authorization": "Bearer ${HiveStorageManager.getUserToken()}"},
                fields: {"user_id": '${HiveStorageManager.getUserId()}', kAddImageNonceVariable : imageNonce!},
                fileField: "property_upload_file",
                httpRequestMethod: 'POST',
                updates: Updates.statusAndProgress,
                displayName: '$imageUploadingLabel $uploadingImageCount/$totalPendingImages',
              );

              uploader.enqueue(task);
              var taskId = task.taskId;

              if (kDebugMode && enableUploadPropertyLogs) {
                print("Task[$j]Id: $taskId");
              }

              ///Save taskId to keep track and assign attachment_id to relevant image record.
              ///when this image uploads.
              _imageMap[IMAGE_TASK_ID] = taskId;
            }

            ///Assign back this map, to keep it updated in the list
            _imageList[j]  = _imageMap;

          }
        }

        _totalProgress = 50;
        if (kDebugMode && enableUploadPropertyLogs) {
          print("Total Progress: $_totalProgress");
        }
        notifyListeners();

        if (kDebugMode && enableUploadPropertyLogs) {
          print("ImagesList with Assigned TaskIds: $_imageList");
        }
        ///Assign back the list in property map, to keep it updated with status.
        if (kDebugMode && enableUploadPropertyLogs) {
          print("Adding ImagesList with Assigned TaskIds to Property Map");
        }
        _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageList;

        ///Assign back this particular property map to 0 index.
        _propertyDataMapsList[0] = _propertyDataMap;

        ///store whole map so we know the proper task id, even after application killed.
        if (kDebugMode && enableUploadPropertyLogs) {
          print("Updating Property Map List in Storage...");
        }
        storeData(_propertyDataMapsList);
      }

      if (noPendingPropertyImage && noFloorPlansPendingImage) {
        floorPlansList = _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS] ?? [];
        /// Remove all Fave Plan Pending Image objects
        if(floorPlansList.isNotEmpty){
          for(var item in floorPlansList){
            if(item.containsKey(favePlanPendingImage)){
              item.remove(favePlanPendingImage);
            }
          }
        }

        _propertyDataMap[ADD_PROPERTY_FLOOR_PLANS] = floorPlansList;
        _propertyDataMapsList[0] = _propertyDataMap;
        storeData(_propertyDataMapsList);

        _totalProgress = 80;
        if (kDebugMode && enableUploadPropertyLogs) {
          print("Total Progress: $_totalProgress");
        }
        notifyListeners();

        if (kDebugMode && enableUploadPropertyLogs) {
          print("No Pending Image Found...");
          print("Uploading Property Via Dio...");
        }

        uploadPropertyViaDio(_propertyDataMap);
      }
    }
  }
  Future<void> uploadPropertyViaDio(Map<String, dynamic> _propertyDataMap) async {
    if (kDebugMode && enableUploadPropertyLogs) {
      print("uploadPropertyViaDio() is called....");
    }
    /// Clear All previous Tasks from Uploader Queue
    if (kDebugMode && enableUploadPropertyLogs) {
      print("Clearing All previous Tasks from Uploader Queue...");
    }
    uploader.taskQueues.clear();

    /// Resetting Task ids List in Hive Storage
    resetTaskIdsList(_tasksIdsList);

    // print("uploadPropertyViaDio() is called...");
    ///
    /// Upload Property via dio.
    /// if property is uploaded successfully then:
    /// 1. Remove the property from the Property Data List.
    /// 2. Update the data in Storage.
    /// 3. Call the uploadPropertyMethod().
    ///
    if (kDebugMode && enableUploadPropertyLogs) {
      print('PropertyManager: uploading via dio');
    }


    int? userId =  HiveStorageManager.getUserId();
    if (userId != null) {
      _propertyDataMap[ADD_PROPERTY_USER_ID] = userId;
    }
    if (kDebugMode && enableUploadPropertyLogs) {
      print("Assigning user id to Property Map...\n UserId: ${_propertyDataMap[ADD_PROPERTY_USER_ID]}");
    }

    var isPropertyForUpdate = (_propertyDataMap[ADD_PROPERTY_ACTION] == ADD_PROPERTY_ACTION_UPDATE);

    String? nonce = _propertyDataMap[ADD_PROPERTY_NONCE];

    if (nonce == null || nonce.isEmpty) {
      ApiResponse? nonceResponse;
      if (isPropertyForUpdate) {
        nonceResponse = await _propertyBloc.fetchUpdatePropertyNonceResponse();
      } else {
        nonceResponse = await _propertyBloc.fetchAddPropertyNonceResponse();
      }

      if (nonceResponse != null && nonceResponse.success) {
        nonce = nonceResponse.result;
      }
    }

    _propertyDataMap[ADD_PROPERTY_NONCE] = nonce;


    Response response;
    if (isPropertyForUpdate){
      if (kDebugMode && enableUploadPropertyLogs) {
        print('Updating Property...');
      }
      response = await _propertyBloc.fetchUpdatePropertyResponse(_propertyDataMap, nonce!);
    }
    else {
      if (kDebugMode && enableUploadPropertyLogs) {
        print('Uploading Property...');
      }
      response = await _propertyBloc.fetchAddPropertyResponse(_propertyDataMap, nonce!);
    }

    if (kDebugMode && enableUploadPropertyLogs) {
      if (isPropertyForUpdate) {
        print('Updating Property Response...');
      } else {
        print('Uploading Property Response...');
      }

      print("Response Status Code: ${response.statusCode}");
      print("Response Status Code: ${response.statusMessage}");
      print("Response Status Code: ${response.data}");
    }

    if (response.statusCode == 200) {

      if (kDebugMode && enableUploadPropertyLogs) {
        if (isPropertyForUpdate) {
          print('Updating Property Complete...');
        } else {
          print('Uploading Property Complete...');
        }
        // print('PropertyManager: uploaded a property');
        // print("response: ${response.data.runtimeType}");
        // print("response: ${response.data}");
      }
      if (response.data is Map) {
        _uploadedPropertyId = response.data['prop_id'];
      } else if (response.data is String) {
        Map tempMap = jsonDecode(response.data);
        _uploadedPropertyId = tempMap['prop_id'];
      }
      _totalProgress = 100;
      if (kDebugMode && enableUploadPropertyLogs) {
        print("Total Progress: $_totalProgress");
        print("Upload Property ID: $_uploadedPropertyId");
      }
      // _uploadedPropertyId = response.data['prop_id'];
      notifyListeners();

      List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertiesDataMaps() ?? [];
      if(_propertyDataMapsList.isNotEmpty){
        Map tempPropertyDataMap = _propertyDataMapsList[0] ?? {};
        int? draftIndex = tempPropertyDataMap[ADD_PROPERTY_DRAFT_INDEX] ?? -1;
        if(draftIndex != null && draftIndex != -1){
          List<dynamic> _draftPropertiesList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
          if(_draftPropertiesList.isNotEmpty) {
            _draftPropertiesList.removeAt(draftIndex);
            HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesList);
          }
        }

        _propertyDataMapsList.removeAt(0);
        if (kDebugMode && enableUploadPropertyLogs) {
          print('Removed Property from _propertyDataMapsList...');
        }

        storeData(_propertyDataMapsList);

        if (kDebugMode && enableUploadPropertyLogs) {
          print('Storage Updated...');
        }
      }
      if (kDebugMode && enableUploadPropertyLogs) {
        print('Calling uploadProperty (Recursion!)...');
      }
      uploadProperty();
    } else {
      if (kDebugMode && enableUploadPropertyLogs) {
        print('PropertyManager: got a dio error ${response.statusCode}');
      }
    }
  }

  void storeData(List<dynamic> dataList){
    HiveStorageManager.storeAddPropertiesDataMaps(dataList);
  }

  void resetTaskIdsList(List _tasksIdsList){
    if (kDebugMode && enableUploadPropertyLogs) {
      print("Resetting Task ids List in Hive Storage...");
    }
    _tasksIdsList.clear();
    HiveStorageManager.storeTasksIdsList(_tasksIdsList);
  }

}


















// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_uploader/flutter_uploader.dart';
// import 'package:houzi_package/blocs/property_bloc.dart';
// import 'package:houzi_package/common/constants.dart';
// import 'package:houzi_package/files/generic_methods/utility_methods.dart';
// import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// /// A class that is used to 'Add' a property as well as notify about the
// /// property uploading. After user provide all the necessary information, it
// /// got saved in the storage.
// ///
// ///
// /// This class has a method [uploadProperty] which uploads the property or
// /// properties in recursive manner. It perform following steps to 'add' the
// /// property:
// ///
// /// 1. It reads the required data to 'add' property from the storage.
// ///
// /// 2. If storage is not null or not empty, it reads the 'List' of
// ///    'to-be-uploaded' properties.
// ///
// /// 3. The property data is always taken from the 0th index of the property
// ///    information list.
// ///
// /// 4. Before uploading the property data to the [API], it always checks for
// ///    any pending image that is yet to be uploaded.
// ///
// /// 5. Each image contains its uploading status, if there is any image that is
// ///    still not uploaded, it is uploaded and the
// ///    information about uploaded image id etc. is updated in image itself and
// ///    the property information as well as in the storage (so that in worst-case scenario
// ///    (App crash), we do not have to upload the 'pending' image again).
// ///
// /// 6. If all the images are uploaded or there are no pending images, then the
// ///    property data in form of 'Form Data', is POSTED to [API] so that
// ///    property could be uploaded.
// ///
// /// 7. If property uploads successfully, then the property data is removed from
// ///    storage list and the 'Upload Property' method is called again.
//
//
//
// void backgroundHandler()  {
//   // Needed so that plugin communication works.
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // This uploader instance works within the isolate only.
//   FlutterUploader uploader = FlutterUploader();
//
//   var notifications = FlutterLocalNotificationsPlugin();
//
//   // Only show notifications for unprocessed uploads.
//   SharedPreferences.getInstance().then((preferences) {
//     var processed = preferences.getStringList('processed') ?? <String>[];
//
//     if (Platform.isAndroid) {
//       uploader.progress.listen((progress) {
//         if (processed.contains(progress.taskId)) {
//           return;
//         }
//
//         notifications.show(
//           progress.taskId.hashCode,
//           'FlutterUploader Example',
//           'Upload in Progress',
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               'FlutterUploader.Example',
//               'FlutterUploader',
//               channelDescription:
//               'Installed when you activate the Flutter Uploader Example',
//               progress: progress.progress ?? 0,
//               icon: 'ic_upload',
//               enableVibration: false,
//               importance: Importance.low,
//               showProgress: true,
//               onlyAlertOnce: true,
//               maxProgress: 100,
//               channelShowBadge: false,
//             ),
//             iOS: const IOSNotificationDetails(),
//           ),
//         );
//       });
//     }
//
//     uploader.result.listen((result) {
//       if (processed.contains(result.taskId)) {
//         return;
//       }
//
//       processed.add(result.taskId);
//       preferences.setStringList('processed', processed);
//
//       notifications.cancel(result.taskId.hashCode);
//
//       final successful = result.status == UploadTaskStatus.complete;
//
//       var title = 'Upload Complete';
//       if (result.status == UploadTaskStatus.failed) {
//         title = 'Upload Failed';
//       } else if (result.status == UploadTaskStatus.canceled) {
//         title = 'Upload Canceled';
//       }
//
//       notifications.show(
//         result.taskId.hashCode,
//         'FlutterUploader Example',
//         title,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'FlutterUploader.Example',
//             'FlutterUploader',
//             channelDescription:
//             'Installed when you activate the Flutter Uploader Example',
//             icon: 'ic_upload',
//             enableVibration: !successful,
//             importance: result.status == UploadTaskStatus.failed
//                 ? Importance.high
//                 : Importance.min,
//           ),
//           iOS: const IOSNotificationDetails(
//             presentAlert: true,
//           ),
//         ),
//       )
//           .catchError((e, stack) {
//         // print('error while showing notification: $e, $stack');
//       });
//     });
//   });
// }
//
//   //   uploader.result.listen((uploadTaskResponse)  {
//   //     // print("UploadTaskResponse: $uploadTaskResponse");
//   //     // print("openBoxAndUpdate() is Called...");
//   //     HiveStorageManager.openHiveBox().then((value) {
//   //       openBoxAndUpdate(uploadTaskResponse, uploader);
//   //       return null;
//   //     });
//   //   }, onDone: ()  {
//   //     // print("Closing Box!");
//   //     HiveStorageManager.closeHiveBox();
//   //   },  onError: (ex, stacktrace) {
//   //     // ... code to handle error
//   //     // print("Found Some Errors...");
//   //     // print("PropertyManager: exception: $ex");
//   //     // print("PropertyManager: stacktrace: $stacktrace" ?? "no stacktrace");
//   //   },
//   //     //     onError: (error){
//   //     //   // print("Found Some Error: $error");
//   //     // }
//   //   );
//   // }
//
// openBoxAndUpdate(UploadTaskResponse uploadTaskResponse, FlutterUploader uploader) async {
//   updateAddPropertiesDataMap(uploadTaskResponse, uploader);
// }
// void updateAddPropertiesDataMap(UploadTaskResponse uploadTaskResponse, FlutterUploader uploader){
//   // print("updateAddPropertiesDataMap() is Called...");
//   // print("Task Id: ${uploadTaskResponse.taskId}");
//   // print("Reading List from Hive Storage...");
//   List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertyDataMaps();
//   if (_propertyDataMapsList == null || _propertyDataMapsList.isEmpty) {
//     // print("List is Empty...");
//     return;
//   }
//   if (_propertyDataMapsList.isNotEmpty) {
//     // print("List is not Empty...");
//     if (uploadTaskResponse.statusCode == 200) {
//       Map map = jsonDecode(uploadTaskResponse.response);
//       Map<String, dynamic> _propertyDataMap = GenericMethods.convertMap(_propertyDataMapsList[0]);
//       ///
//       /// if property uploading is already in Progress, then there is no need to do anything
//       if(_propertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] == ADD_PROPERTY_UPLOAD_STATUS_IN_PROGRESS){
//         // print("Property Upload Status: InProgress...");
//         return;
//       }
//       String attachmentId = map[ATTACHMENT_ID].toString();
//       // print("attachment_id: $attachmentId..............................................................");
//       // print("Uploaded Image Attachment Id: $attachmentId");
//       String taskId = uploadTaskResponse.taskId;
//       ///
//       /// Update the image status and set the attachment id we got from server.
//       ///
//       List<dynamic> _imageList = _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST];
//       for (int i = 0; i < _imageList.length; i++) {
//         Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[i]);
//         String imageTaskId = _imageMap[IMAGE_TASK_ID];
//         if (taskId == imageTaskId) {
//           // print("Uploaded Image Task Id Matched..."
//               "\nTaskId: $taskId"
//               "\nImageTaskId: $imageTaskId"
//           );
//           _imageMap[PROPERTY_MEDIA_IMAGE_STATUS] = UPLOADED;
//           _imageMap[ATTACHMENT_ID] = attachmentId;
//           // print("Image Status Changed to UPLOADED");
//         }
//         ///Necessary step to update the original array
//         _imageList[i] = _imageMap;
//       } // for loop
//
//       ///Necessary step to update the original map
//       _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageList;
//
//       int totalPendingImages = 0;
//       /// Find the total pending images.
//       for (int j = 0; j < _imageList.length; j++) {
//         Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[j]);
//         String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//         if (imageStatus == PENDING) {
//           totalPendingImages++;
//         }
//       }
//       // print("Total Pending Images: $totalPendingImages");
//       ///
//       /// Check if all the images have been uploaded.
//       ///
//       if (totalPendingImages == 0) {
//         // print("No Pending Images...");
//         // print("All the images have been uploaded, \nNow upload property...");
//
//         String _featuredImageLocalId = _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID];
//
//         List<String> _propertyImageIdsList = [];
//         for (int j = 0; j < _imageList.length; j++) {
//           Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[j]);
//           String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//           String attachmentId = _imageMap[ATTACHMENT_ID].toString();
//           if (imageStatus == UPLOADED) {
//             _propertyImageIdsList.add(attachmentId);
//           }
//           ///
//           /// if uploaded image has the same local_id as of featured image local_id then
//           /// set the Uploaded id to Property Featured Image Id:
//           ///
//           if (_featuredImageLocalId == _imageMap['ImageId']) {
//             _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_ID] = attachmentId;
//             // print("Setting Featured Image Attachment Id...\nFeatured Image Attachment Id: $attachmentId");
//           }
//         }
//         ///
//         /// if already have image ids in property map, just append these newly updated list.
//         /// otherwise create new.
//         ///
//         if (_propertyDataMap.containsKey(ADD_PROPERTY_IMAGE_IDS)) {
//           List<dynamic> exPropertyImageIdsList = _propertyDataMap[ADD_PROPERTY_IMAGE_IDS];
//           exPropertyImageIdsList.addAll(_propertyImageIdsList);
//           _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = exPropertyImageIdsList;
//           // print("Appending Images Attachment Ids List to Property Data Map...");
//         } else {
//           _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = _propertyImageIdsList;
//           // print("Adding Images Attachment Ids List to Property Data Map...");
//         }
//         ///
//         /// if property upload Status is "Pending" then upload it
//         if(_propertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] == ADD_PROPERTY_UPLOAD_STATUS_PENDING){
//           // print("Property Upload Status: Pending...");
//           ///
//           ///Going to upload this property, store its status as 'in_progress'
//           _propertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] = ADD_PROPERTY_UPLOAD_STATUS_IN_PROGRESS;
//           // print("Changing Property Upload Status to In Progress...");
//           ///
//           ///Necessary step to update the original map
//           _propertyDataMapsList[0] = _propertyDataMap;
//           ///
//           /// Update the data in Storage:
//           // print("Updating Data in Storage...");
//           PropertyManager.storeData(_propertyDataMapsList);
//           // print("Uploading Property Via Dio...");
//           PropertyManager.uploadPropertyViaDio(_propertyDataMap, uploader);
//         }
//       } else {
//         // print("There are still some Pending Images...");
//         ///Necessary step to update the original map
//         _propertyDataMapsList[0] = _propertyDataMap;
//         ///
//         /// Update the data in Shared Preferences:
//         // print("Updating Data in Storage...");
//         PropertyManager.storeData(_propertyDataMapsList);
//         // print("Closing Box!");
//         // Box hiveBox = Hive.box(HIVE_BOX);
//         // hiveBox.close();
//         // Hive.close();
//       }
//     }
//   }
// }
//
// class PropertyManager with ChangeNotifier {
//   /// static PropertyManager _instance;
//   /// static PropertyManager getState() {
//   ///   if (_instance == null) {
//   ///     _instance = PropertyManager._internal();
//   ///  }
//   ///
//   ///   return _instance;
//   /// }
//   static PropertyManager _propertyManager;
//   factory PropertyManager() {
//     if (_propertyManager == null) {
//       _propertyManager = PropertyManager._internal();
//     }
//     return _propertyManager;
//   }
//
//   String imageUploadingLabel = "Uploading";
//
//   PropertyBloc _propertyBloc = PropertyBloc();
//
//   bool _isPropertyUploaderFree = true;
//   bool get isPropertyUploaderFree => _isPropertyUploaderFree;
//
//
//   int _uploadedPropertyId;
//
//
//
//   set uploadedPropertyId(int value) {
//     _uploadedPropertyId = value;
//   }
//
//   int get uploadedPropertyId => _uploadedPropertyId;
//
//
//   final uploader = FlutterUploader();
//   StreamSubscription _resultSubscription;
//   ///
//   /// Initializer of Class Network Manager
//   ///
//   PropertyManager._internal(){
//
//     uploader.setBackgroundHandler(backgroundHandler);
//
//     /// Clear All previous Tasks from Uploader Queue
//     // print("Clearing All previous Tasks from Uploader Queue...");
//     uploader.clearUploads();
//     ///
//     /// Listener for Flutter Uploader:
//     ///
//     // _resultSubscription = uploader.result.listen((result) async {
//     //   List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertyDataMaps();
//     //   if(_propertyDataMapsList.isNotEmpty){
//     //     if(result.statusCode == 200){
//     //       Map map = jsonDecode(result.response);
//     //       Map<String, dynamic> _propertyDataMap = GenericMethods.convertMap(_propertyDataMapsList[0]);
//     //       String attachmentId = map[ATTACHMENT_ID].toString();
//     //       String taskId = result.taskId;
//     //
//     //       ///
//     //       /// Update the image status and set the attachment id we got from server.
//     //       ///
//     //       List<dynamic> _imageList = _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST];
//     //
//     //       for(int i = 0; i < _imageList.length; i++){
//     //         Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[i]);
//     //         String imageTaskId = _imageMap[IMAGE_TASK_ID];
//     //         if (taskId == imageTaskId) {
//     //           _imageMap[PROPERTY_MEDIA_IMAGE_STATUS] = UPLOADED;
//     //           _imageMap[ATTACHMENT_ID] = attachmentId;
//     //         }
//     //
//     //         ///Necessary step to update the original array
//     //         _imageList[i] = _imageMap;
//     //       } // for loop
//     //
//     //       ///Necessary step to update the original map
//     //       _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageList;
//     //
//     //
//     //       int totalPendingImages = 0;
//     //
//     //       //find total pending images.
//     //       for (int j = 0; j < _imageList.length; j++) {
//     //         Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[j]);
//     //         String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//     //         if (imageStatus == PENDING) {
//     //           totalPendingImages++;
//     //         }
//     //       }
//     //
//     //       ///
//     //       /// Check if all the images have been uploaded.
//     //       ///
//     //       if(totalPendingImages == 0) {
//     //         String _featuredImageLocalId = _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID];
//     //
//     //         List<String> _propertyImageIdsList = [];
//     //
//     //         for (int j = 0; j < _imageList.length; j++) {
//     //           Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[j]);
//     //           String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//     //           String attachmentId = _imageMap[ATTACHMENT_ID].toString();
//     //           if (imageStatus == UPLOADED) {
//     //             _propertyImageIdsList.add(attachmentId);
//     //           }
//     //           ///
//     //           /// if uploaded image has the same local_id as of featured image local_id then
//     //           /// set the Uploaded id to Property Featured Image Id:
//     //           ///
//     //           if(_featuredImageLocalId == _imageMap['ImageId']){
//     //             _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_ID] = attachmentId;
//     //           }
//     //         }
//     //         ///
//     //         /// if already have image ids in property map, just append these newly updated list.
//     //         /// otherwise create new.
//     //         ///
//     //         if(_propertyDataMap.containsKey(ADD_PROPERTY_IMAGE_IDS)){
//     //           List<dynamic>  exPropertyImageIdsList = _propertyDataMap[ADD_PROPERTY_IMAGE_IDS];
//     //
//     //           exPropertyImageIdsList.addAll(_propertyImageIdsList);
//     //           _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = exPropertyImageIdsList;
//     //         }else{
//     //
//     //           _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = _propertyImageIdsList;
//     //         }
//     //
//     //         ///Necessary step to update the original map
//     //         _propertyDataMapsList[0] = _propertyDataMap;
//     //         ///
//     //         /// Update the data in Shared Preferences:
//     //         ///
//     //         storeData(_propertyDataMapsList);
//     //
//     //         ///
//     //         /// Upload Property via dio.
//     //         /// if property is uploaded successfully then:
//     //         /// 1. Remove the property from the Property Data List.
//     //         /// 2. Update the data in Storage.
//     //         /// 3. Call the uploadProperty().
//     //         ///
//     //         _propertyDataMap[ADD_PROPERTY_USER_ID] = HiveStorageManager.getUserId();
//     //
//     //         uploadPropertyViaDio(_propertyDataMap, uploader);
//     //       } else {
//     //         ///Necessary step to update the original map
//     //         _propertyDataMapsList[0] = _propertyDataMap;
//     //
//     //         ///
//     //         /// Update the data in Shared Preferences:
//     //         ///
//     //         storeData(_propertyDataMapsList);
//     //       }
//     //     }
//     //
//     //   }
//     //
//     // }, onError: (ex, stacktrace) {
//     //   // print("PropertyManager: exception: $ex");
//     //   // print("PropertyManager: stacktrace: $stacktrace" ?? "no stacktrace");
//     //
//     // });
//   }
//
//   void uploadProperty(){
//     // print("uploadProperty() is called...");
//     uploadPropertyMethod(uploader);
//   }
//
//   static uploadPropertyMethod(FlutterUploader uploader) async {
//     // print("uploadPropertyMethod() is called...");
//     PropertyBloc _propertyBloc = PropertyBloc();
//     String imageUploadingLabel = "Uploading";
//     ///
//     /// Check for any pending properties in Storage:
//     ///
//     // print("Checking for any pending properties in Storage...");
//     List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertyDataMaps();
//     ///
//     /// If found any pending property, upload pending properties using Recursion.
//     /// Base case: when there is no property left in list.
//     ///
//     if(_propertyDataMapsList == null){
//       // print('PropertyManager: No Property to be Uploaded...');
//       return;
//     }
//
//     if (_propertyDataMapsList.length == 0) {
//       // _isPropertyUploaderFree = true;
//       // notifyListeners();
//       // print('PropertyManager: All Properties Uploaded...');
//       return;
//     }
//     ///
//     /// Notify the observers that property / properties are being uploaded.
//     ///
//     // _isPropertyUploaderFree = false;
//     // notifyListeners();
//
//     // print('PropertyManager: Found some properties');
//
//     Map<String, dynamic> _propertyDataMap = GenericMethods.convertMap(_propertyDataMapsList[0]);
//     bool noPendingImage = true;
//     ///
//     /// Check for pending property images:
//     ///
//     // print("Checking for pending property images...");
//     List<dynamic> _imageList = _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST];
//     int totalPendingImages = 0;
//     if(_imageList != null){
//
//       int uploadingImageCount = 0;
//
//       //find total pending images.
//       for (int j = 0; j < _imageList.length; j++) {
//         Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[j]);
//         String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//         if (imageStatus == PENDING) {
//           totalPendingImages++;
//         }
//       }
//
//       // print("Total pending images: $totalPendingImages");
//
//       /// Clear All previous Tasks from Uploader Queue
//       if(totalPendingImages > 0){
//         // print("Clearing All previous Tasks from Uploader Queue...");
//         uploader.clearUploads();
//       }
//
//       for (int j = 0; j < _imageList.length; j++) {
//         Map<String, dynamic> _imageMap = GenericMethods.convertMap(_imageList[j]);
//         String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//
//         if (imageStatus == PENDING) {
//           noPendingImage = false;
//           uploadingImageCount++;
//           final String imagePath = _imageMap[PROPERTY_MEDIA_IMAGE_PATH];
//           /// if imageMap already has task id then remove it.
//           if(_imageMap.containsKey(IMAGE_TASK_ID)){
//             _imageMap.remove(IMAGE_TASK_ID);
//           }
//
//           var taskId = await uploader.enqueue(
//           // final taskId = await uploader.enqueue(
//             MultipartFormDataUpload(
//               url: '${_propertyBloc.provideSavePropertyImagesApi()}',
//               files: [
//                 FileItem(
//                   path: imagePath,
//                   field: "property_upload_file")
//               ],
//               headers: {"Authorization": "Bearer ${HiveStorageManager.getUserToken()}"},
//               method: UploadMethod.POST,
//               data: {"user_id": '${HiveStorageManager.getUserId()}'},
//               tag: '$imageUploadingLabel $uploadingImageCount/$totalPendingImages',
//             ),
//           );
//
//           // print("Task[$j]Id: $taskId");
//
//           ///Save taskId to keep track and assign attachment_id to relevant image record.
//           ///when this image uploads.
//           _imageMap[IMAGE_TASK_ID] = taskId;
//
//           ///Assign back this map, to keep it updated in the list
//           _imageList[j]  = _imageMap;
//
//         }
//       }
//
//       // print("ImagesList with Assigned TaskIds: $_imageList");
//       ///Assign back the list in property map, to keep it updated with status.
//       // print("Adding ImagesList with Assigned TaskIds to Property Map");
//       _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageList;
//
//       ///Assign back this particular property map to 0 index.
//       _propertyDataMapsList[0] = _propertyDataMap;
//
//       ///store whole map so we know the proper task id, even after application killed.
//       // print("Updating Property Map List in Storage...");
//       storeData(_propertyDataMapsList);
//
//       // print("Closing Box...");
//       // await Hive.close();
//     }
//
//     if (noPendingImage == true) {
//       // print("No Pending Image Found...");
//       // print("Uploading Property Via Dio...");
//       uploadPropertyViaDio(_propertyDataMap, uploader);
//     }
//   }
//   static Future<void> uploadPropertyViaDio(Map<String, dynamic> _propertyDataMap, FlutterUploader uploader) async {
//     // print("uploadPropertyViaDio() is called...");
//     PropertyBloc _propertyBloc = PropertyBloc();
//     ///
//     /// Upload Property via dio.
//     /// if property is uploaded successfully then:
//     /// 1. Remove the property from the Property Data List.
//     /// 2. Update the data in Storage.
//     /// 3. Call the uploadPropertyMethod().
//     ///
//     // print('PropertyManager: uploading via dio');
//
//     _propertyDataMap[ADD_PROPERTY_USER_ID] = HiveStorageManager.getUserId();
//     // print("Assigning user id to Property Map...\n UserId: ${_propertyDataMap[ADD_PROPERTY_USER_ID]}");
//
//     var isPropertyForUpdate = _propertyDataMap[ADD_PROPERTY_ACTION] == ADD_PROPERTY_ACTION_UPDATE;
//     var response;
//     if(isPropertyForUpdate){
//       // print('Updating Property...');
//       response = await _propertyBloc.fetchUpdatePropertyResponse(_propertyDataMap);
//     }
//     else {
//       // print('Uploading Property...');
//       response = await _propertyBloc.fetchAddPropertyResponse(_propertyDataMap);
//     }
//
//     if (response.statusCode == 200) {
//       // print('Property Uploaded...');
//       // print('PropertyManager: uploaded a property');
//       // _uploadedPropertyId = response.data['prop_id'];
//       // notifyListeners();
//       List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertyDataMaps();
//       _propertyDataMapsList.removeAt(0);
//       // print('Removed Property from _propertyDataMapsList...');
//       storeData(_propertyDataMapsList);
//       // print('Storage Updated...');
//
//       // /// Clear All previous Tasks from Uploader Queue
//       // print("Clearing All previous Tasks from Uploader Queue...");
//       // uploader.clearUploads();
//       //
//       // print("Closing Box...");
//       // await Hive.close();
//
//       // print('Calling uploadPropertyMethod (Recursion!)...');
//       // print("Closing Box!");
//       // Box hiveBox = Hive.box(HIVE_BOX);
//       // hiveBox.close();
//       // Hive.close();
//       uploadPropertyMethod(uploader);
//     } else {
//       // print('PropertyManager: got a dio error ${response.statusCode}');
//     }
//   }
//   static void storeData(List<dynamic> dataList){
//     HiveStorageManager.storeAddPropertyDataMaps(dataList);
//   }
//
// }



























// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_uploader/flutter_uploader.dart';
// import 'package:houzi_package/blocs/property_bloc.dart';
// import 'package:houzi_package/common/constants.dart';
// import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
// import 'package:path/path.dart';
//
//
// /// A class that is used to 'Add' a property as well as notify about the
// /// property uploading. After user provide all the necessary information, it
// /// got saved in the storage.
// ///
// ///
// /// This class has a method [uploadProperty] which uploads the property or
// /// properties in recursive manner. It perform following steps to 'add' the
// /// property:
// ///
// /// 1. It reads the required data to 'add' property from the storage.
// ///
// /// 2. If storage is not null or not empty, it reads the 'List' of
// ///    'to-be-uploaded' properties.
// ///
// /// 3. The property data is always taken from the 0th index of the property
// ///    information list.
// ///
// /// 4. Before uploading the property data to the [API], it always checks for
// ///    any pending image that is yet to be uploaded.
// ///
// /// 5. Each image contains its uploading status, if there is any image that is
// ///    still not uploaded, it is uploaded and the
// ///    information about uploaded image id etc. is updated in image itself and
// ///    the property information as well as in the storage (so that in worst-case scenario
// ///    (App crash), we do not have to upload the 'pending' image again).
// ///
// /// 6. If all the images are uploaded or there are no pending images, then the
// ///    property data in form of 'Form Data', is POSTED to [API] so that
// ///    property could be uploaded.
// ///
// /// 7. If property uploads successfully, then the property data is removed from
// ///    storage list and the 'Upload Property' method is called again.
//
//
// class PropertyManager with ChangeNotifier {
//   /// static PropertyManager _instance;
//   /// static PropertyManager getState() {
//   ///   if (_instance == null) {
//   ///     _instance = PropertyManager._internal();
//   ///  }
//   ///
//   ///   return _instance;
//   /// }
//   static PropertyManager _propertyManager;
//   factory PropertyManager() {
//      if (_propertyManager == null) {
//        _propertyManager = PropertyManager._internal();
//      }
//      return _propertyManager;
//   }
//
//   String imageUploadingLabel = "Uploading";
//
//   PropertyBloc _propertyBloc = PropertyBloc();
//
//   bool _isPropertyUploaderFree = true;
//   bool get isPropertyUploaderFree => _isPropertyUploaderFree;
//
//
//   int _uploadedPropertyId;
//
//
//
//   set uploadedPropertyId(int value) {
//     _uploadedPropertyId = value;
//   }
//
//   int get uploadedPropertyId => _uploadedPropertyId;
//
//
//   final uploader = FlutterUploader();
//   StreamSubscription _resultSubscription;
//
//
//   ///
//   /// Initializer of Class Network Manager
//   ///
//   PropertyManager._internal(){
//
//     ///
//     /// Listener for Flutter Uploader:
//     ///
//     _resultSubscription = uploader.result.listen((result) async {
//       List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertyDataMaps();
//       if(_propertyDataMapsList.isNotEmpty){
//
//         if(result.statusCode == 200){
//           Map map = jsonDecode(result.response);
//           Map<String, dynamic> _propertyDataMap = convertMap(_propertyDataMapsList[0]);
//           String attachmentId = map[ATTACHMENT_ID].toString();
//           String taskId = result.taskId;
//
//           ///
//           /// Update the image status and set the attachment id we got from server.
//           ///
//           List<dynamic> _imageList = _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST];
//
//           for(int i = 0; i < _imageList.length; i++){
//             Map<String, dynamic> _imageMap = convertMap(_imageList[i]);
//             String imageTaskId = _imageMap[IMAGE_TASK_ID];
//             if (taskId == imageTaskId) {
//               _imageMap[PROPERTY_MEDIA_IMAGE_STATUS] = UPLOADED;
//               _imageMap[ATTACHMENT_ID] = attachmentId;
//             }
//
//             ///Necessary step to update the original array
//             _imageList[i] = _imageMap;
//           } // for loop
//
//           ///Necessary step to update the original map
//           _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageList;
//
//
//           int totalPendingImages = 0;
//
//           //find total pending images.
//           for (int j = 0; j < _imageList.length; j++) {
//             Map<String, dynamic> _imageMap = convertMap(_imageList[j]);
//             String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//             if (imageStatus == PENDING) {
//               totalPendingImages++;
//             }
//           }
//
//           ///
//           /// Check if all the images have been uploaded.
//           ///
//           if(totalPendingImages == 0) {
//             String _featuredImageLocalId = _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID];
//
//             List<String> _propertyImageIdsList = [];
//
//             for (int j = 0; j < _imageList.length; j++) {
//               Map<String, dynamic> _imageMap = convertMap(_imageList[j]);
//               String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//               String attachmentId = _imageMap[ATTACHMENT_ID].toString();
//               if (imageStatus == UPLOADED) {
//                 _propertyImageIdsList.add(attachmentId);
//               }
//               ///
//               /// if uploaded image has the same local_id as of featured image local_id then
//               /// set the Uploaded id to Property Featured Image Id:
//               ///
//               if(_featuredImageLocalId == _imageMap['ImageId']){
//                 _propertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_ID] = attachmentId;
//               }
//             }
//             ///
//             /// if already have image ids in property map, just append these newly updated list.
//             /// otherwise create new.
//             ///
//             if(_propertyDataMap.containsKey(ADD_PROPERTY_IMAGE_IDS)){
//               List<dynamic>  exPropertyImageIdsList = _propertyDataMap[ADD_PROPERTY_IMAGE_IDS];
//
//               exPropertyImageIdsList.addAll(_propertyImageIdsList);
//               _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = exPropertyImageIdsList;
//             }else{
//
//               _propertyDataMap[ADD_PROPERTY_IMAGE_IDS] = _propertyImageIdsList;
//             }
//
//             ///Necessary step to update the original map
//             _propertyDataMapsList[0] = _propertyDataMap;
//             ///
//             /// Update the data in Shared Preferences:
//             ///
//             storeData(_propertyDataMapsList);
//
//             ///
//             /// Upload Property via dio.
//             /// if property is uploaded successfully then:
//             /// 1. Remove the property from the Property Data List.
//             /// 2. Update the data in Storage.
//             /// 3. Call the uploadProperty().
//             ///
//             _propertyDataMap[ADD_PROPERTY_USER_ID] = HiveStorageManager.getUserId();
//
//             uploadPropertyViaDio(_propertyDataMap);
//           } else {
//             ///Necessary step to update the original map
//             _propertyDataMapsList[0] = _propertyDataMap;
//
//             ///
//             /// Update the data in Shared Preferences:
//             ///
//             storeData(_propertyDataMapsList);
//           }
//         }
//
//       }
//
//     }, onError: (ex, stacktrace) {
//       // print("PropertyManager: exception: $ex");
//       // print("PropertyManager: stacktrace: $stacktrace" ?? "no stacktrace");
//
//     });
//   }
//
//   uploadProperty() async {
//
//     ///
//     /// Check for any pending properties in Storage:
//     ///
//     List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertyDataMaps();
//
//
//     ///
//     /// If found any pending property, upload pending properties using Recursion.
//     /// Base case: when there is no property left in list.
//     ///
//     if(_propertyDataMapsList == null){
//       // print('PropertyManager: No Property to be Uploaded...');
//       return;
//     }
//
//     if (_propertyDataMapsList.length == 0) {
//       _isPropertyUploaderFree = true;
//       notifyListeners();
//       // print('PropertyManager: All Properties Uploaded...');
//       return;
//     }
//     ///
//     /// Notify the observers that property / properties are being uploaded.
//     ///
//     _isPropertyUploaderFree = false;
//     notifyListeners();
//
//     // print('PropertyManager: Found some properties');
//
//     Map<String, dynamic> _propertyDataMap = convertMap(_propertyDataMapsList[0]);
//     bool noPendingImage = true;
//     ///
//     /// Check for pending property images:
//     ///
//     List<dynamic> _imageList = _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST];
//     int totalPendingImages = 0;
//     if(_imageList != null){
//
//       int uploadingImageCount = 0;
//
//       //find total pending images.
//       for (int j = 0; j < _imageList.length; j++) {
//         Map<String, dynamic> _imageMap = convertMap(_imageList[j]);
//         String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//         if (imageStatus == PENDING) {
//           totalPendingImages++;
//         }
//       }
//
//       for (int j = 0; j < _imageList.length; j++) {
//         Map<String, dynamic> _imageMap = convertMap(_imageList[j]);
//         String imageStatus = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
//
//         if (imageStatus == PENDING) {
//           noPendingImage = false;
//           uploadingImageCount++;
//           var fileName = _imageMap['ImageName'];
//           final String savedDir = dirname(_imageMap[PROPERTY_MEDIA_IMAGE_PATH]);
//
//           final taskId = await uploader.enqueue(
//             url: '${_propertyBloc.provideSavePropertyImagesApi()}',
//             files: [
//               FileItem(
//                   filename: fileName,
//                   savedDir: savedDir,
//                   fieldname: "property_upload_file")
//             ],
//             headers: {"Authorization": "Bearer ${HiveStorageManager.getUserToken()}"},
//             method: UploadMethod.POST,
//             data: {"user_id": '${HiveStorageManager.getUserId()}'},
//             showNotification: true,
//             tag: '${imageUploadingLabel} $uploadingImageCount/$totalPendingImages',
//             // tag: 'Uploading Image $uploadingImageCount/$totalPendingImages',
//             // tag: '${_propertyDataMap[ADD_PROPERTY_LOCAL_ID]}_${_image['ImageId']}',
//           );
//
//           ///Save taskId to keep track and assign attachment_id to relevant image record.
//           ///when this image uploads.
//           _imageMap[IMAGE_TASK_ID] = taskId;
//
//           ///Assign back this map, to keep it updated in the list
//           _imageList[j]  = _imageMap;
//
//         }
//       }
//       ///Assign back the list in property map, to keep it updated with status.
//       _propertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageList;
//
//       ///Assign back this particular property map to 0 index.
//       _propertyDataMapsList[0] = _propertyDataMap;
//
//       ///store whole map so we know the proper task id, even after application killed.
//       storeData(_propertyDataMapsList);
//     }
//
//     if (noPendingImage == true) {
//         uploadPropertyViaDio(_propertyDataMap);
//     }
//   }
//   Future<void> uploadPropertyViaDio(Map<String, dynamic> _propertyDataMap) async {
//     ///
//     /// Upload Property via dio.
//     /// if property is uploaded successfully then:
//     /// 1. Remove the property from the Property Data List.
//     /// 2. Update the data in Storage.
//     /// 3. Call the uploadProperty().
//     ///
//     // print('PropertyManager: uploading via dio');
//
//     _propertyDataMap[ADD_PROPERTY_USER_ID] = HiveStorageManager.getUserId();
//     var isPropertyForUpdate = _propertyDataMap[ADD_PROPERTY_ACTION] == ADD_PROPERTY_ACTION_UPDATE;
//     var response;
//     if(isPropertyForUpdate){
//       response = await _propertyBloc.fetchUpdatePropertyResponse(_propertyDataMap);
//     }
//     else {
//       response = await _propertyBloc.fetchAddPropertyResponse(_propertyDataMap);
//     }
//
//     if (response.statusCode == 200) {
//       // print('PropertyManager: uploaded a property');
//       _uploadedPropertyId = response.data['prop_id'];
//       notifyListeners();
//       List<dynamic> _propertyDataMapsList = HiveStorageManager.readAddPropertyDataMaps();
//       _propertyDataMapsList.removeAt(0);
//       storeData(_propertyDataMapsList);
//       uploadProperty();
//     } else {
//       // print('PropertyManager: got a dio error ${response.statusCode}');
//     }
//   }
//   void storeData(List<dynamic> dataList){
//     HiveStorageManager.storeAddPropertyDataMaps(dataList);
//   }
//
//   static Map<String, dynamic> convertMap(Map<dynamic, dynamic> inputMap){
//     Map<dynamic, dynamic> data = inputMap;
//     Map<String, dynamic> convertedMap =  Map<String, dynamic>();
//     if(data != null){
//       for (dynamic type in data.keys) {
//         convertedMap[type.toString()] = data[type];
//       }
//     }
//     return convertedMap;
//   }
//
// }