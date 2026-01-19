import Service, { service } from "@ember/service";
import { TrackedMap } from "@ember-compat/tracked-built-ins";
import { smallUserAttrs } from "discourse/components/small-user-list";

const LIKE_ACTION = 2;

// Default state to return when post doesn't have state yet
// This avoids modifying the TrackedMap during render
const DEFAULT_STATE = Object.freeze({
  isVisible: false,
  users: [],
  totalUsers: 0,
  loading: false,
});

export default class InlineLikesState extends Service {
  @service store;

  // Map of post ID to { isVisible, users, totalUsers }
  postLikesMap = new TrackedMap();

  // Read-only getter - does NOT modify the map
  getState(postId) {
    return this.postLikesMap.get(postId) || DEFAULT_STATE;
  }

  // Ensures state exists in map (call this in actions, not during render)
  ensureState(postId) {
    if (!this.postLikesMap.has(postId)) {
      this.postLikesMap.set(postId, {
        isVisible: false,
        users: [],
        totalUsers: 0,
        loading: false,
      });
    }
    return this.postLikesMap.get(postId);
  }

  isVisible(postId) {
    return this.getState(postId).isVisible;
  }

  getUsers(postId) {
    return this.getState(postId).users;
  }

  getTotalUsers(postId) {
    return this.getState(postId).totalUsers;
  }

  getRemainingUsers(postId) {
    const state = this.getState(postId);
    return state.totalUsers - state.users.length;
  }

  isLoading(postId) {
    return this.getState(postId).loading;
  }

  async toggleWhoLiked(postId) {
    const state = this.ensureState(postId);

    if (state.isVisible) {
      this.postLikesMap.set(postId, {
        ...state,
        isVisible: false,
      });
      return;
    }

    await this.fetchWhoLiked(postId);
  }

  async fetchWhoLiked(postId) {
    const state = this.ensureState(postId);

    if (state.loading) {
      return;
    }

    this.postLikesMap.set(postId, {
      ...state,
      loading: true,
    });

    try {
      const users = await this.store.find("post-action-user", {
        id: postId,
        post_action_type_id: LIKE_ACTION,
      });

      this.postLikesMap.set(postId, {
        isVisible: true,
        users: users.content.map(smallUserAttrs),
        totalUsers: users.totalRows,
        loading: false,
      });
    } catch (e) {
      this.postLikesMap.set(postId, {
        ...this.ensureState(postId),
        loading: false,
      });
      throw e;
    }
  }

  // Called when a like is toggled to refresh the list if visible
  async refreshIfVisible(postId) {
    const state = this.getState(postId);
    if (state.isVisible || state.users.length > 0) {
      await this.fetchWhoLiked(postId);
    }
  }

  // Clear state for a post (e.g., when leaving the page)
  clear(postId) {
    this.postLikesMap.delete(postId);
  }
}
