import Component from "@glimmer/component";
import TopicPostBadges from "discourse/components/topic-post-badges";
import avatar from "discourse/helpers/avatar";
import icon from "discourse/helpers/d-icon";
import formatDate from "discourse/helpers/format-date";
import { number } from "discourse/lib/formatter";
import { withPluginApi } from "discourse/lib/plugin-api";

class MobileOutletComponent extends Component {
  static shouldRender(_args, context) {
    return context.site.mobileView;
  }
}

class EmptyAvatarContent extends MobileOutletComponent {
  <template>{{~! no whitespace ~}}</template>
}

class TopicBadgeMobContent extends MobileOutletComponent {
  <template>
    <TopicPostBadges
      @unreadPosts={{@outletArgs.topic.unread_posts}}
      @url={{@outletArgs.topic.lastUnreadUrl}}
    />
  </template>
}

class CommentViewsLikesContent extends MobileOutletComponent {
  <template>
    <span class="comments">
      {{icon "far-comment"}}
      <a href={{@outletArgs.topic.firstPostUrl}}>{{number
          @outletArgs.topic.replyCount
          noTitle="true"
        }}
      </a>
    </span>
    <span class="topic-views">
      {{icon "far-eye"}} {{number @outletArgs.topic.views numberKey="views_long"}}
    </span>
    <span class="topic-likes">
      {{icon "far-heart"}}
      <a href={{@outletArgs.topic.summaryUrl}}>{{number @outletArgs.topic.like_count}}</a>
    </span>
  </template>
}

class LastPostContent extends MobileOutletComponent {
  <template>
    <td class="last-post">
      <div class="poster-avatar">
        <a
          href={{@outletArgs.topic.lastPostUrl}}
          data-user-card={{@outletArgs.topic.last_poster_username}}
        >{{avatar @outletArgs.topic.lastPosterUser imageSize="small"}}
        </a>
      </div>
      <div class="num activity last poster-info">
        <span title={{@outletArgs.topic.bumpedAtTitle}} class="age activity">
          <a href={{@outletArgs.topic.lastPostUrl}}>{{formatDate
              @outletArgs.topic.bumpedAt
              format="tiny"
              noTitle="true"
            }}
          </a>
        </span>
      </div>
    </td>
  </template>
}

function initialize(api) {
  api.renderInOutlet("topic-list-item-mobile-avatar", EmptyAvatarContent);
  api.renderInOutlet("topic-list-after-title", TopicBadgeMobContent);
  api.renderInOutlet("topic-list-after-category", CommentViewsLikesContent);
  api.renderAfterWrapperOutlet("topic-list-item", LastPostContent);
}

export default {
  name: "md-topic-list-mobile",

  initialize() {
    withPluginApi("1.28.0", (api) => initialize(api));
  },
};
