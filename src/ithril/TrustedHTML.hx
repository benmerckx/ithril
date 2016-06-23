package ithril;

@:allow(ithril.Ithril)
@:allow(ithril.HTMLRenderer)
private class TrustedHTML {
  var body: String;

  public function new(body: String) {
    this.body = body;
  }

  public function toString() {
    return body;
  }
}
