import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/src/map/bmf_models.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

class MapRoute extends StatefulWidget {
  const MapRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MapRouteState();
  }
}

class MapRouteState extends State<MapRoute> {
  late TextEditingController positionController;
  late LocationFlutterPlugin _locationPlugin;
  BaiduLocationIOSOption iosOption =
      BaiduLocationIOSOption(coordType: BMFLocationCoordType.gcj02);
  BaiduLocationAndroidOption androidOption =
      BaiduLocationAndroidOption(coordType: BMFLocationCoordType.gcj02);
  late BMFMapController _controller;
  late BaiduLocation _location;

  @override
  void initState() {
    super.initState();

    positionController = TextEditingController();
    _locationPlugin = LocationFlutterPlugin();
    _locationPlugin.setAgreePrivacy(true);
    _location = BaiduLocation();
    _locationPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      _location = result;
      _stopLocation();
      updatePosition();
    });

    // _startLocation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "选取地点",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          MaterialButton(
            child: const Text("确定", style: TextStyle(fontSize: 15)),
            onPressed: () {},
          )
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black)),
      ),
      body: _map(),
    );
  }

  Widget _map() {
    return Container(
      child: Column(
        children: [
          Container(
            child: TextField(
                controller: positionController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "请输入地点",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    suffix: Container(
                      child: MaterialButton(
                        child: const Text("确认"),
                        onPressed: () {
                          serchPosition(positionController.text);
                        },
                      ),
                    ))),
          ),
          Expanded(
            child: BMFMapWidget(
              onBMFMapCreated: (controller) {
                //自定义onBMFMapCreated方法，用于获取controller
                onBMFMapCreated(controller);
              },
              mapOptions: BMFMapOptions(
                center: BMFCoordinate(39.917215, 116.380341),
                zoomLevel: 12,
                mapPadding:
                    BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onBMFMapCreated(BMFMapController controller) {
    _controller = controller;
    _controller.showUserLocation(true);
    showToast("created");
  }

  //  申请权限
  Future<bool> requestPermission() async {
    // 申请权限
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("定位权限申请通过");
      return true;
    } else {
      print("定位权限申请不通过");
      return false;
    }
  }

  /// 停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

//  开始定位
  void _startLocation() {
    if (null != _locationPlugin) {
      //申请定位权限
      requestPermission().then((value) => {
            if (value)
              {_setLocOption(), _locationPlugin.startLocation()}
            else
              {showToast("需要定位权限")}
          });
    }
  }

//  设置定位参数
  void _setLocOption() {
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddress(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(BMFLocationMode.hightAccuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
    Map androidMap = androidOption.getMap();
    Map iosdMap = iosOption.getMap();
    _locationPlugin.prepareLoc(androidMap, iosdMap); //ios和安卓定位设置
  }

  Future<void> serchPosition(String text) async {
// 构造检索参数
    BMFSuggestionSearchOption suggestionSearchOption =
        BMFSuggestionSearchOption(
            keyword: text, cityname: _location.city ?? "北京");
// 检索实例
    BMFSuggestionSearch suggestionSearch = BMFSuggestionSearch();
// 检索回调
    suggestionSearch.onGetSuggestSearchResult(callback:
        (BMFSuggestionSearchResult result, BMFSearchErrorCode errorCode) {
      print('sug检索回调 result = ${result.toMap()} \n errorCode = ${errorCode}');
      // 解析reslut，具体参考demo
    });
// 发起检索
    bool flag = await suggestionSearch.suggestionSearch(suggestionSearchOption);
  }

  void updatePosition() {
    BMFCoordinate coordinate = BMFCoordinate(
        _location.latitude ?? 39.917215, _location.longitude ?? 116.380341);

    BMFMapOptions options = BMFMapOptions(
        center: coordinate,
        zoomLevel: 17,
        mapPadding: BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0));

    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);

    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );

    _controller.updateLocationData(userLocation);
    _controller.updateMapOptions(options);
  }
}
