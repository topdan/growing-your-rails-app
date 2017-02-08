module DashboardsHelper

  def recent_activity(posts)
    Dashboards::PostsBox.new(self, {
      title: t('dashboards.recent_activity.title'),
      posts: posts
    }).render
  end

  def product_news(posts)
    Dashboards::PostsBox.new(self, {
      title: t('dashboards.product_news.title'),
      posts: posts
    }).render
  end

end
