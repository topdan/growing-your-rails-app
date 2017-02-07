class Dashboards::RecentActivity < ApplicationViewComponent

  attr_accessor :id
  attr_accessor :title

  def initialize(template, posts)
    super(template)
    @posts = posts

    # These values could be inferred from the class name
    @id = 'dashboard_recent_activity'
    @title = t('dashboards.recent_activity.title')
  end

  def render
    box(id: id, title: title, content: content)
  end

  def refresh
    %($('##{id}').html("#{j render}");)
  end

  private

  def content
    safe_join @posts.collect do |post|
      render_post(post)
    end
  end

  def render_post(post)
    title = content_tag(:p) do
      link_to(post.title, template.post_path(post)) <<
        post.published_at.to_s(:datestamp)
    end

    description = content_tag(:p, truncate(post.description))

    title << description
  end

end
