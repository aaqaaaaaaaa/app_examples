class CourseModel {
  final String imgUrl;
  final String title;
  final String authorName;
  final String authorImg;
  final String date;
  final String hashTag;

  CourseModel(
      {required this.imgUrl,
      required this.title,
      required this.authorName,
      required this.authorImg,
      required this.date,
      required this.hashTag});
}
