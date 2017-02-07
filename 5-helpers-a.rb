module DashboardsHelper

  def recent_activity(posts)
    Dashboards::RecentActivity.new(self, posts).render
  end

  def product_news(posts)
    Dashboards::ProductNews.new(self, posts).render
  end

end
