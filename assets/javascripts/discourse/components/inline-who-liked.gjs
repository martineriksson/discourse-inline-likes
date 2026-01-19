import Component from "@glimmer/component";
import { getOwner } from "@ember/owner";
import SmallUserList from "discourse/components/small-user-list";

export default class InlineWhoLiked extends Component {
  get inlineLikesState() {
    return getOwner(this).lookup("service:inline-likes-state");
  }

  get postId() {
    return this.args.post.id;
  }

  get isVisible() {
    const svc = this.inlineLikesState;
    return svc ? svc.isVisible(this.postId) : false;
  }

  get users() {
    const svc = this.inlineLikesState;
    return svc ? svc.getUsers(this.postId) : [];
  }

  get totalUsers() {
    const svc = this.inlineLikesState;
    return svc ? svc.getTotalUsers(this.postId) : 0;
  }

  get remainingUsers() {
    const svc = this.inlineLikesState;
    return svc ? svc.getRemainingUsers(this.postId) : 0;
  }

  get addSelf() {
    return this.args.post.liked && this.remainingUsers === 0;
  }

  get count() {
    return this.remainingUsers > 0 ? this.remainingUsers : this.totalUsers;
  }

  get description() {
    return this.remainingUsers > 0
      ? "post.actions.people.like_capped"
      : "post.actions.people.like";
  }

  <template>
    {{#if this.isVisible}}
      <SmallUserList
        class="who-liked"
        @addSelf={{this.addSelf}}
        @isVisible={{true}}
        @count={{this.count}}
        @description={{this.description}}
        @users={{this.users}}
      />
    {{/if}}
  </template>
}
