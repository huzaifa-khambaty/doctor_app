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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['has_next'] = this.hasNext;
    data['has_previous'] = this.hasPrevious;
    return data;
  }
}