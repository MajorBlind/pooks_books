bool isNewerVersion(String latest, String current){
  String prefix = "v";
  latest = latest.replaceFirst(prefix, "");
  current = current.replaceFirst(prefix, "");
}