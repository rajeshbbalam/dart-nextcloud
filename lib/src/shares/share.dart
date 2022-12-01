import 'package:xml/xml.dart' as xml;

/// Share class
class Share {
  // ignore: public_member_api_docs
  Share({
    required this.id,
    required this.shareType,
    required this.uidOwner,
    required this.displaynameOwner,
    required this.permissions,
    required this.stime,
    required this.parent,
    required this.expiration,
    required this.token,
    required this.uidFileOwner,
    required this.note,
    required this.label,
    required this.displaynameFileOwner,
    required this.path,
    required this.itemType,
    required this.mimeType,
    required this.storageId,
    required this.storage,
    required this.itemSource,
    required this.fileSource,
    required this.fileParent,
    required this.fileTarget,
    required this.shareWith,
    required this.shareWithDisplayName,
    required this.mailSend,
    required this.hideDownload,
    required this.password,
    required this.url,
  });

  /// The share id
  final int id;

  /// Integer defined in [ShareTypes]
  final int shareType;

  // ignore: public_member_api_docs
  final String uidOwner;

  // ignore: public_member_api_docs
  final String displaynameOwner;

  // ignore: public_member_api_docs
  final Permissions permissions;

  // ignore: public_member_api_docs
  final int stime;

  // ignore: public_member_api_docs
  final String parent;

  // ignore: public_member_api_docs
  final DateTime expiration;

  // ignore: public_member_api_docs
  final String token;

  // ignore: public_member_api_docs
  final String uidFileOwner;

  // ignore: public_member_api_docs
  final String note;

  // ignore: public_member_api_docs
  final String label;

  // ignore: public_member_api_docs
  final String displaynameFileOwner;

  // ignore: public_member_api_docs
  final String path;

  // ignore: public_member_api_docs
  final String itemType;

  // ignore: public_member_api_docs
  final String mimeType;

  // ignore: public_member_api_docs
  final String storageId;

  // ignore: public_member_api_docs
  final int storage;

  // ignore: public_member_api_docs
  final int itemSource;

  // ignore: public_member_api_docs
  final int fileSource;

  // ignore: public_member_api_docs
  final int fileParent;

  // ignore: public_member_api_docs
  final String fileTarget;

  // ignore: public_member_api_docs
  final String shareWith;

  // ignore: public_member_api_docs
  final String shareWithDisplayName;

  // ignore: public_member_api_docs
  final int mailSend;

  // ignore: public_member_api_docs
  final int hideDownload;

  /// Password for public link share
  final String password;

  /// Url for public link share
  final String url;

  /// Returns if the file is a directory
  bool get isDirectory => itemType == 'folder';

  @override
  String toString() =>
      'Share{path: $path, id: $id owner: $displaynameOwner, shareWith: $shareWith, permissions: $permissions, url: $url, ...}';
}

/// Defines all possible share types
class ShareTypes {
  /// Share with user
  static const user = 0;

  /// Share with group
  static const group = 1;

  /// Create a public link share
  static const publicLink = 3;

  /// All possible share types
  static const values = [user, group, publicLink];
}

/// Defines the permission
class Permission {
  /// Read only
  static const read = 1;

  /// Update only
  static const update = 2;

  /// Create only
  static const create = 4;

  /// Update only
  static const delete = 8;

  /// Share only
  static const share = 16;

  /// All permissions
  static const all = 31;

  /// All possible permission values
  static const values = [all, read, update, create, delete, share];
}

/// Defines the combination of permissions
class Permissions {
  /// Create permissions by the integer lists of [Permission].VALUE objects
  Permissions(List<int> permissions) {
    _permissions = permissions;
  }

  /// Create permissions the the combined permission integer
  factory Permissions.fromInt(int number) {
    // ignore: omit_local_variable_types
    final List<int> permissions = [];
    // ignore: avoid_function_literals_in_foreach_calls
    Permission.values.reversed.forEach((value) {
      if (number >= value) {
        number -= value;
        permissions.add(value);
      }
    });
    return Permissions(permissions);
  }

  /// Add a permission if not existing
  void addPermission(int permission) {
    if (!_permissions.contains(permission)) {
      _permissions.add(permission);
    }
  }

  /// Remove a permission if existing
  void removePermission(int permission) {
    if (_permissions.contains(permission)) {
      _permissions.remove(permission);
    }
  }

  /// Create the combined permissions integer
  int toInt() {
    var number = 0;
    for (final value in permissions) {
      number += value;
    }
    return number;
  }

  late List<int> _permissions;

  /// Returns the separated permissions as list
  List<int> get permissions => _permissions;

  @override
  String toString() => '${toInt()}: $_permissions';
}

/// Converts the shares xml to a list of share objects
List<Share> sharesFromSharesXml(String xmlStr) {
  // Initialize a list to store the FileInfo Objects
  final tree = [];

  // parse the xml using the xml.XmlDocument.parse method
  final xmlDocument = xml.XmlDocument.parse(xmlStr);

  // Iterate over the response to find all share elements and parse the information
  for (final response in xmlDocument.findAllElements('element')) {
    tree.add(shareFromShareXml(response));
  }
  return tree.cast<Share>();
}

/// Converts the shares xml to a list of share objects
List<Share> sharesFromSharesJson(Map<String, dynamic> json) {
  // Initialize a list to store the FileInfo Objects
  final tree = [];
  final List data = json['ocs']['data'] as List;
  // Iterate over the response to find all share elements and parse the information
  for (final shareJson in data) {
    tree.add(shareFromShareJson(shareJson as Map<String, dynamic>));
  }
  return tree.cast<Share>();
}

/// Converts the shares xml to a list of share objects
Share shareFromRequestResponseXml(String xmlStr) {
  // parse the xml using the xml.XmlDocument.parse method
  final xmlDocument = xml.XmlDocument.parse(xmlStr);

  // Get the created share
  final response = xmlDocument.findAllElements('data').single;
  return shareFromShareXml(response);
}

/// Converts a share xml a a share object
Share shareFromShareXml(xml.XmlElement element) {
  final id = int.parse(element.findAllElements('id').single.text);
  final shareType =
      int.parse(element.findAllElements('share_type').single.text);
  final stime = int.parse(element.findAllElements('stime').single.text);
  final uidOwner = element.findAllElements('uid_owner').single.text;
  final displaynameOwner =
      element.findAllElements('displayname_owner').single.text;
  final parent = element.findAllElements('parent').single.text;
  final expiration =
      DateTime.parse(element.findAllElements('expiration').single.text);
  final token = element.findAllElements('token').single.text;
  final uidFileOwner = element.findAllElements('uid_file_owner').single.text;
  final note = element.findAllElements('note').single.text;
  final label = element.findAllElements('label').single.text;
  final displaynameFileOwner =
      element.findAllElements('displayname_file_owner').single.text;
  final path = element.findAllElements('path').single.text;
  final itemType = element.findAllElements('item_type').single.text;
  final mimeType = element.findAllElements('mimetype').single.text;
  final storageId = element.findAllElements('storage_id').single.text;
  final storage = int.parse(element.findAllElements('storage').single.text);
  final itemSource =
      int.parse(element.findAllElements('item_source').single.text);
  final fileSource =
      int.parse(element.findAllElements('file_source').single.text);
  final fileParent =
      int.parse(element.findAllElements('file_parent').single.text);
  final fileTarget = element.findAllElements('file_target').single.text;
  final shareWith = element.findAllElements('share_with').single.text;
  final shareWithDisplayName =
      element.findAllElements('share_with_displayname').single.text;
  final mailSend = int.parse(element.findAllElements('mail_send').single.text);
  final hideDownload =
      int.parse(element.findAllElements('hide_download').single.text);
  final password = element.findAllElements('password').toList()[0].text;
  final url = element.findAllElements('url').toList()[0].text;

  final permissionsNumber =
      int.parse(element.findAllElements('permissions').single.text);
  final permissions = Permissions.fromInt(permissionsNumber);

  return Share(
    id: id,
    shareType: shareType,
    uidOwner: uidOwner,
    displaynameOwner: displaynameOwner,
    permissions: permissions,
    stime: stime,
    parent: parent,
    expiration: expiration,
    token: token,
    uidFileOwner: uidFileOwner,
    note: note,
    label: label,
    displaynameFileOwner: displaynameFileOwner,
    path: path,
    itemType: itemType,
    mimeType: mimeType,
    storageId: storageId,
    storage: storage,
    itemSource: itemSource,
    fileSource: fileSource,
    fileParent: fileParent,
    fileTarget: fileTarget,
    shareWith: shareWith,
    shareWithDisplayName: shareWithDisplayName,
    mailSend: mailSend,
    hideDownload: hideDownload,
    password: password,
    url: url,
  );
}

/// Converts a share xml a a share object
Share shareFromShareJson(Map<String, dynamic> json) {
  Map<String, dynamic>? data = (json['ocs'] != null ? json['ocs']['data'] : json) as Map<String, dynamic>;

  final permissionsNumber = data['permissions'] as int;
  final permissions = Permissions.fromInt(permissionsNumber);

  return Share(
    id: data['id'] != null ? int.parse(data['id'] as String) : -1,
    shareType: data['share_type'] != null ? data['share_type'] as int : -1,
    uidOwner: data['uid_owner'] != null ? (data['uid_owner'] as String) : '',
    displaynameOwner: data['displayname_owner'] != null ? (data['displayname_owner'] as String) : '',
    permissions: permissions,
    stime: data['stime'] != null ? (data['stime'] as int) : -1,
    parent: data['parent'] != null ? (data['parent'] as String) : '',
    expiration: data['expiration'] != null ? DateTime.parse(data['expiration'] as String) : DateTime.now(),
    token: data['token'] != null ? (data['token'] as String) : '',
    uidFileOwner: data['uid_file_owner'] != null ? (data['uid_file_owner'] as String) : '',
    note: data['note'] != null ? (data['note'] as String) : '',
    label: data['label'] != null ? (data['label'] as String) : '',
    displaynameFileOwner: data['displayname_file_owner'] != null ? (data['displayname_file_owner'] as String) : '',
    path: data['path'] != null ? (data['path'] as String) : '',
    itemType: data['item_type'] != null ? (data['item_type'] as String) : '',
    mimeType: data['mimetype'] != null ? (data['mimetype'] as String) : '',
    storageId: data['storage_id'] != null ? (data['storage_id'] as String) : '',
    storage: data['storage'] != null ? (data['storage'] as int) : -1,
    itemSource: data['item_source'] != null ? (data['item_source'] as int) : -1,
    fileSource: data['file_source'] != null ? (data['file_source'] as int) : -1,
    fileParent: data['file_parent'] != null ? (data['file_parent'] as int) : -1,
    fileTarget: data['file_target'] != null ? (data['file_target'] as String) : '',
    shareWith: data['share_with'] != null ? (data['share_with'] as String) : '',
    shareWithDisplayName: data['share_with_displayname'] != null ? (data['share_with_displayname'] as String) : '',
    mailSend: data['mail_send'] != null ? (data['mail_send'] as int) : -1,
    hideDownload: data['hide_download'] != null ? (data['hide_download'] as int) : -1,
    password: data['password'] != null ? data['password'] as String : '',
    url: (data['url'] != null ? (data['url'] as String) : '').replaceAll("http", "https"),
  );
}
