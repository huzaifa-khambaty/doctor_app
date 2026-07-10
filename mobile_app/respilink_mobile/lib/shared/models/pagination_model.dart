class Pagination {
  int? page;
  int? perPage;
  int? total;
  int? lastPage;
  bool? hasNext;
  bool? hasPrevious;

  Pagination(
      {this.page,
      this.perPage,
      this.total,
      this.lastPage,
      this.hasNext,
      this.hasPrevious});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    hasNext = json['has_next'];
    hasPrevious = json['has_previous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['per_page'] = perPage;
    data['total'] = total;
    data['last_page'] = lastPage;
    data['has_next'] = hasNext;
    data['has_previous'] = hasPrevious;
    return data;
  }
}