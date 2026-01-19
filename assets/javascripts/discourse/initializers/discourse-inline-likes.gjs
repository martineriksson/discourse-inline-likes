import Component from "@glimmer/component";
import { withPluginApi } from "discourse/lib/plugin-api";
import InlineLikeButton from "../components/inline-like-button";
import InlineWhoLiked from "../components/inline-who-liked";

function initializeInlineLikes(api) {
  // Replace the default like button with our inline version
  api.registerValueTransformer(
    "post-menu-buttons",
    ({ value: dag, context: { buttonKeys } }) => {
      dag.replace(buttonKeys.LIKE, InlineLikeButton);
    }
  );

  // Render the who-liked list after the post menu
  api.renderInOutlet(
    "post-menu__after",
    class extends Component {
      static shouldRender(args) {
        // Only render if the post has likes
        return args.post.likeCount > 0;
      }

      <template>
        <InlineWhoLiked @post={{@outletArgs.post}} />
      </template>
    }
  );
}

export default {
  name: "discourse-inline-likes",

  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");

    if (siteSettings.discourse_inline_likes_enabled) {
      withPluginApi(initializeInlineLikes);
    }
  },
};
