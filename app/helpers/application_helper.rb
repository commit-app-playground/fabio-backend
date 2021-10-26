module ApplicationHelper
  def body(&block)
    base = ([params[:controller], action_name] + request.variant).join '/'
    content_tag(:body, id: base.tr('/', '_'), class: base.tr('/', ' '), &block)
  end
end
