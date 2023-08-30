import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/helpers/helpers.dart';
import 'package:tour_guide_admin/models/tour.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_add_tour.dart';

import '../../../models/stop.dart';
import '../../layouts/item_admin_tour.dart';

class ScreenAdminMobileDashboard extends StatefulWidget {
  const ScreenAdminMobileDashboard({Key? key}) : super(key: key);

  @override
  _ScreenAdminMobileDashboardState createState() => _ScreenAdminMobileDashboardState();
}

class _ScreenAdminMobileDashboardState extends State<ScreenAdminMobileDashboard> {
  ScrollController? _scrollController;

  bool lastStatus = true;

  double height = 160;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null && _scrollController!.hasClients && _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    getTours();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  bool loading = true;
  List<Tour> tours = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      elevation: 1,
                      backgroundColor: Colors.white,
                      pinned: true,
                      expandedHeight: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * .24,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        collapseMode: CollapseMode.parallax,
                        title: _isShrink
                            ? Text(
                                LocaleKeys.TourGuide.tr,
                                style: normal_h1Style_bold.copyWith(color: appPrimaryColor),
                              )
                            : null,
                        background: Container(
                          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/images/home_bg.png"))),
                          child: Stack(
                            // alignment: AlignmentDirectional.center,
                            children: [
                              Positioned.fill(
                                  child: Container(
                                color: Color(0xFF4F4F4F).withOpacity(.5),
                              )),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocaleKeys.Dashboard.tr,
                                        style: heading2_style.copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        "Logo",
                                        style: heading2_style.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: CustomScrollView(
                  scrollBehavior: ScrollBehavior(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ItemAdminTour(
                            tour: tours[index],
                          );
                        },
                        childCount: tours.length,
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_circle_outlined,
            size: 28.sp,
          ),
          onPressed: () {
            Get.to(ScreenAdminMobileAddTour());
          },
        ),
      ),
    );
  }

  void getTours() {
    toursRef.snapshots().listen((event) {
      if (mounted) {
        setState(() {
          tours = event.docs.map((e) => Tour.fromMap(e.data() as Map<String, dynamic>)).toList();
          loading = false;
          print(tours.length);
        });
      }
    });
  }

}
