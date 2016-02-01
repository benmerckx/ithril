package ithril;

class TrustedHTML {
  var body: String;

  public function new(body: String) {
    this.body = body;
    #if js
    untyped return m.trust(body);
    #end
  }

  public function toString() {
    return body;
  }
}
