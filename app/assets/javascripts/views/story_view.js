Hummingbird.StoryView = Ember.View.extend({
  classNames: ["story"],

  templateName: function() {
    if (this.get('content.isDeleted')) {
      return "story/deleted";
    }
    return "story/" + this.get('content.type');
  }.property('content.type', 'content.isDeleted'),

  rerenderOnDeletion: function() {
    this.rerender();
  }.observes('content.isDeleted'),

  didInsertElement: function() {
    var commentEl = this.$('.comment-text')[0];
    if (commentEl && commentEl.offsetHeight < commentEl.scrollHeight) {
      this.controller.set('overflowing', true);
    }
  }
});
