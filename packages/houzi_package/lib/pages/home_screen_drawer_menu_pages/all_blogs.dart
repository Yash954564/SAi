import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/blogs_related/blogs_listing_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';


class AllBlogsPage extends StatefulWidget {
  final String title;
  final String blogDesign;
  final bool? hideBackButton;

  const AllBlogsPage({
    super.key,
    required this.title,
    required this.blogDesign,
    this.hideBackButton = false,
  });

  @override
  _AllBlogsPageState createState() => _AllBlogsPageState();
}

class _AllBlogsPageState extends State<AllBlogsPage> {
  final PropertyBloc _propertyBloc = PropertyBloc();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<BlogArticle> blogsArticlesList = [];
  Future<BlogArticlesData?>? _futureBlogArticlesList;

  bool isLoading = false;
  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isInternetConnected = true;

  int page = 1;
  int perPage = 20;

  @override
  void initState() {
    super.initState();
    loadDataFromApi();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: widget.title,
        automaticallyImplyLeading: !(widget.hideBackButton ?? false),
      ),
      body: Stack(
        children: [
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: () => loadDataFromApi(),
            onLoading: () => loadDataFromApi(forPullToRefresh: false),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget? body;
                if (mode == LoadStatus.loading) {
                  if (shouldLoadMore) {
                    body = const PaginationLoadingWidget();
                  } else {
                    body = Container();
                  }
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: BlogsListingsFromFuture(
                loadingData: isLoading,
                design: widget.blogDesign,
                future: _futureBlogArticlesList,
                // future: null,
                listener: (loadingComplete) {
                  isLoading = false;
                },
              ),
            ),
          ),
          if (_refreshController.isLoading)
            const PaginationLoadingWidget(),

          if (isInternetConnected == false) Align(
            alignment: Alignment.topCenter,
            child: NoInternetConnectionErrorWidget(onPressed: () => loadDataFromApi()),
          )
        ],
      ),
    );
  }

  void loadDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
      setState(() {
        isRefreshing = true;
        isLoading = true;
      });

      page = 1;
      _futureBlogArticlesList = fetchBlogArticles(page);
      _refreshController.refreshCompleted();
    } else {
      if (!shouldLoadMore || isLoading) {
        _refreshController.loadComplete();
        return;
      }
      setState(() {
        isRefreshing = false;
        isLoading = true;
      });
      page++;
      _futureBlogArticlesList = fetchBlogArticles(page);
      _refreshController.loadComplete();
    }
  }

  Future<BlogArticlesData?> fetchBlogArticles(int page) async {
    Map<String, dynamic> dataMap = {
      "page" : page.toString(),
      "per_page" : perPage.toString(),
    };

    var(success, internet, blogsData) = await _propertyBloc.fetchBlogArticles(dataMap);
    if (mounted) {
      setState(() {
        isInternetConnected = internet;
        if (!internet) {
          shouldLoadMore = false;
        }
      });
    }

    if (success) {
      if (page == 1) {
        blogsArticlesList = [];
      }
      if (blogsData != null) {
        List<BlogArticle>? tempList = blogsData.articlesList;

        if (tempList != null && tempList.isNotEmpty) {
          blogsArticlesList.addAll(tempList);
          blogsData.articlesList = blogsArticlesList;
        } else if (blogsArticlesList.isNotEmpty) {
          blogsData.articlesList = blogsArticlesList;
        }

        if (tempList == null || tempList.isEmpty || tempList.length < perPage) {
          if (mounted) {
            setState(() {
              shouldLoadMore = false;
            });
          }
        }
      }

      return blogsData;
    }

    return null;
  }
}

typedef BlogsListingsFromFutureListener = void Function(bool loadingComplete);
class BlogsListingsFromFuture extends StatelessWidget {
  final bool loadingData;
  final String design;
  final Future<BlogArticlesData?>? future;
  final BlogsListingsFromFutureListener listener;

  const BlogsListingsFromFuture({
    super.key,
    required this.loadingData,
    required this.design,
    required this.future,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BlogArticlesData?>(
      future: future,
      builder: (context, articleSnapshot) {
        listener(true);
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data == null ||
              articleSnapshot.data!.articlesList == null ||
              articleSnapshot.data!.articlesList!.isEmpty) {
            return const NoPostsFoundWidget();
          }

          List<BlogArticle> list = articleSnapshot.data!.articlesList!;

          return Container(
            padding: const EdgeInsets.only(top: 15),
            child: BlogsListingWidget(
              view: LIST_VIEW,
              design: design,
              articlesList: list,
            ),
          );
        } else if (!loadingData && (articleSnapshot.hasError || (!articleSnapshot.hasData))) {
          return const NoPostsFoundWidget();
        }
        return const LoadingWidget();
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) / 2,
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 80,
        height: 20,
        child: BallBeatLoadingWidget(),
      ),
    );
  }
}

class PaginationLoadingWidget extends StatelessWidget {
  const PaginationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const SizedBox(
        width: 60,
        height: 50,
        child: BallRotatingLoadingWidget(),
      ),
    );
  }
}

class NoPostsFoundWidget extends StatelessWidget {
  const NoPostsFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80),
      child: const NoResultErrorWidget(
        headerErrorText: "No Posts Found",
      ),
    );
  }
}