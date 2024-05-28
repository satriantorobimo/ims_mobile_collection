class Attachment {
  int taskId;
  String path;
  String basename;
  String ext;
  String size;
  String date;

  Attachment(
      {required this.taskId,
      required this.path,
      required this.basename,
      required this.ext,
      required this.date,
      required this.size});

  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'path': path,
      'basename': basename,
      'ext': ext,
      'size': size,
      'date': date,
    };
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      taskId: map['task_id'],
      path: map['path'],
      basename: map['basename'],
      ext: map['ext'],
      size: map['size'],
      date: map['date'],
    );
  }
}
