class HomeState {
  final bool loading;
  final dynamic data;
  final int page;
  final int lastpage;
  HomeState({this.data,
  this.loading = false,
  this.page =1,
  this.lastpage =1,
  });
  HomeState copyWith({
    final dynamic data,
    bool? loading,
    int? page,
    int? lastpage,
  }) {
    return HomeState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      page: page ?? this.page,
      lastpage: lastpage ?? this.lastpage,
    );
  }
}
