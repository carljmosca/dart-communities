library linkify_text;

import "dart:html";

import 'package:polymer/polymer.dart';
import 'package:emoji/emoji.dart';

import 'package:woven/src/shared/input_formatter.dart';
import 'package:woven/config/config.dart';
import 'package:woven/src/client/routing/router.dart';

@CustomTag("format-text")
class FormatText extends PolymerElement {
  @published Router router;

  NodeValidator validator = new NodeValidatorBuilder()
    ..allowElement('a', attributes: ['on-click'])
    ..allowHtml5(uriPolicy: new DefaultUriPolicy())
    ..allowImages(new DefaultUriPolicy());

  FormatText.created() : super.created();

  format() {
    return replaceWithEmojis(
        InputFormatter.formatMentions(
            InputFormatter.linkify(
                this.text, internalHost: config['server']['domain']
            )
        )
    );
  }

  attached() {
    Element container = this.shadowRoot.querySelector('#container');
    this.injectBoundHtml(format(), validator: validator, element: container);
  }

  changePage(MouseEvent e) {
    e.stopPropagation();
    router.previousPage = 'lobby';
    router.changePage(e);
  }
}

class DefaultUriPolicy implements UriPolicy {
  DefaultUriPolicy();

  // Allow all external, absolute URLs.
  RegExp regex = new RegExp(r'(?:http://|https://|//)?.*');

  bool allowsUri(String uri) {
    return regex.hasMatch(uri);
  }
}