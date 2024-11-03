import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

class CRMNotesListings extends StatefulWidget {
  final String id;
  final String fetch;
  const CRMNotesListings({Key? key, required this.id, required this.fetch}) : super(key: key);

  @override
  State<CRMNotesListings> createState() => _CRMNotesListingsState();
}

class _CRMNotesListingsState extends State<CRMNotesListings> {

  final formKey = GlobalKey<FormState>();
  final CRMRepository _crmRepository = CRMRepository();
  final _noteTextController = TextEditingController();

  Future<List<dynamic>>? _futureNotesFromBoard;
  List<dynamic> notesFromBoardList = [];

  bool isLoading = false;
  bool shouldLoadMore = true;
  bool showIndicatorWidget = false;

  int page = 1;
  int perPage = 10;

  String nonce = "";

  @override
  void initState() {
    super.initState();
    fetchNotes();
    fetchNonce();
  }

  fetchNotes() {
    notesFromBoardList = [];
    _futureNotesFromBoard = fetchNotesFromBoard().then((value) {
        notesFromBoardList = value;
        setState(() {});
        return notesFromBoardList;
      },
    );

    setState(() {});
  }

  fetchNonce() async {
    ApiResponse response = await _crmRepository.fetchLeadDeleteNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  Future<List<dynamic>> fetchNotesFromBoard() async {
    List<dynamic> tempList = [];
    if(widget.fetch == FETCH_INQUIRY) {
      tempList = await _crmRepository.fetchInquiryDetailNotesFromBoard(widget.id);
    } else if (widget.fetch == FETCH_LEAD) {
      tempList = await _crmRepository.fetchLeadsDetailNotesFromBoard(widget.id);
    }

    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          // isInternetConnected = false;
        });
      }

      return notesFromBoardList;
    } else {
      if (tempList.isNotEmpty) {
        notesFromBoardList.addAll(tempList);

      }
    }

    return notesFromBoardList;
    // return tempList;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                addNoteWidget(),
                showInquiryNotesList(context, _futureNotesFromBoard),
              ],
            ),
            loadingIndicatorWidget(),

          ],
        ),
      ),
    );
  }

  Widget showInquiryNotesList(BuildContext context,
      Future<List<dynamic>>? futureInquiryDetailNotesFromBoard) {
    return FutureBuilder<List<dynamic>>(
      future: futureInquiryDetailNotesFromBoard,
      builder: (context, articleSnapshot) {
        isLoading = false;

        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return Container();
          }
          // if (articleSnapshot.data.length < perPage) {
          //   shouldLoadMore = false;
          //   _refreshController.loadNoData();
          // }

          List<dynamic> inquiriesFromBoard = articleSnapshot.data!;

          // if (isRefreshing) {
          //   //need to clear the list if refreshing.
          //   inquiriesFromBoardList.clear();
          // }
          //inquiriesFromBoardList.addAll(list);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: inquiriesFromBoard.length,
            itemBuilder: (context, index) {
              if (inquiriesFromBoard.isEmpty) {
                return const NoResultErrorWidget();
              }

              if (inquiriesFromBoard[index] is! CRMNotes) {
                return Container();
              }
              CRMNotes inquiryNotes = inquiriesFromBoard[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: CardWidget(
                  shape: AppThemePreferences.roundedCorners(
                      AppThemePreferences.globalRoundedCornersRadius),
                  elevation: AppThemePreferences.boardPagesElevation,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CRMTypeHeadingWidget("notes", inquiryNotes.time),
                              CRMNormalTextWidget(inquiryNotes.note),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ShowDialogBoxWidget(
                                context,
                                title:
                                UtilityMethods.getLocalizedString("delete"),
                                content: GenericTextWidget(
                                    UtilityMethods.getLocalizedString(
                                        "delete_confirmation")),
                                actions: <Widget>[
                                  TextButtonWidget(
                                    onPressed: () => Navigator.pop(context),
                                    child: GenericTextWidget(
                                        UtilityMethods.getLocalizedString(
                                            "cancel")),
                                  ),
                                  TextButtonWidget(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        showIndicatorWidget = true;
                                      });
                                      Map<String, dynamic> dataMap = {
                                        NOTE_ID: inquiryNotes.noteId,
                                      };

                                      final response = await _crmRepository.fetchDeleteCRMNotesResponse(dataMap);
                                      String tempResponseString =
                                      response.toString().split("{")[1];
                                      Map map = jsonDecode(
                                          "{${tempResponseString.split("}")[0]}}");

                                      if (map["success"] == true) {
                                        setState(() {
                                          showIndicatorWidget = false;
                                        });
                                        notesFromBoardList.removeAt(index);
                                        setState(() {});
                                        _showToast(
                                            context,
                                            UtilityMethods.getLocalizedString(
                                                "note_deleted"));
                                      } else {
                                        setState(() {
                                          showIndicatorWidget = false;
                                        });
                                        _showToast(context, map["reason"]);
                                      }
                                    },
                                    child: GenericTextWidget(
                                        UtilityMethods.getLocalizedString("yes")),
                                  ),
                                ],
                              );
                            },
                            child: Icon(
                              AppThemePreferences.deleteIcon,
                              color: AppThemePreferences.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return loadingIndicatorWidget();
      },
    );
  }

  Widget addNoteWidget() {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 20),
            child: TextFormFieldWidget(
                controller: _noteTextController,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                labelText: UtilityMethods.getLocalizedString("notes"),
                hintText: UtilityMethods.getLocalizedString("enter_note"),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return UtilityMethods.getLocalizedString(
                        "this_field_cannot_be_empty");
                  }
                  return null;
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ButtonWidget(
              text: UtilityMethods.getLocalizedString("add_notes"),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  setState(() {
                    showIndicatorWidget = true;
                  });

                  String noteType = "";
                  if(widget.fetch == FETCH_INQUIRY) {
                    noteType = ENQUIRY;
                  } else if(widget.fetch == FETCH_LEAD) {
                    noteType = LEAD;
                  }

                  Map<String, dynamic> dataMap = {
                    NOTE: _noteTextController.text,
                    BELONG_TO: widget.id,
                    NOTE_TYPE: noteType
                  };

                  final response = await _crmRepository.fetchAddCRMNotesResponse(dataMap, nonce);
                  String tempResponseString = response.toString().split("{")[1];
                  Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

                  if (map["success"] == true) {
                    _showToast(context, map["msg"]);
                    _noteTextController.clear();
                    fetchNotes();
                  } else {
                    _showToast(context, map["reason"]);
                  }

                  setState(() {
                    showIndicatorWidget = false;
                  });

                }
              }),
        ),
      ],
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget loadingIndicatorWidget() {
    return showIndicatorWidget == true
        ? Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 80,
                  height: 20,
                  child: BallBeatLoadingWidget(),
                ),
              ),
            ),
          )
        : Container();
  }

}
