class MyRoute {
  final String name;
  final String guid;
  final String? parentName;
  final String? parentGuid;
  final bool isFolder;
  final List<MyRoute> children;
  MyRoute({
    required this.name,
    required this.guid,
    this.parentName,
    this.parentGuid,
    required this.isFolder,
    List<MyRoute>? children,
  }) : children = children ?? [];

  factory MyRoute.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['children'] as List<dynamic>?;

    return MyRoute(
      name: json['name'],
      guid: json['guid'],
      parentName: json['parent_name'] != "" ? json['parent_name'] : null,
      parentGuid: json['parent_guid'] != "" ? json['parent_guid'] : null,
      isFolder: json['is_folder'] == 'true',
      children: childrenJson != null
          ? childrenJson
              .map((childJson) => MyRoute.fromJson(childJson))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'guid': guid,
      'parent_name': parentName ?? "",
      'parent_guid': parentGuid ?? "",
      'is_folder': isFolder ? 'true' : 'false',
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

class RoutesResponse {
  final List<MyRoute> routes;
  final String errorMessage;

  RoutesResponse({
    required this.routes,
    required this.errorMessage,
  });

  factory RoutesResponse.empty() {
    return RoutesResponse(
      errorMessage: '',
      routes: [],
    );
  }

  factory RoutesResponse.fromJson(Map<String, dynamic> json) {
    var routesJson = json['routes'] as List;
    List<MyRoute> routesList =
        routesJson.map((routeJson) => MyRoute.fromJson(routeJson)).toList();

    return RoutesResponse(
      routes: routesList,
      errorMessage: json['ErrorMassage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routes': routes.map((route) => route.toJson()).toList(),
      'ErrorMassage': errorMessage,
    };
  }
}
