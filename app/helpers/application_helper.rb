module ApplicationHelper
  def resource_name
    :user
  end

  def resource
      @resource ||= User.new
  end

  def resource_class
      User
  end

  def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
  end

  def to_markdown(text)
      html_render_options = {
        filter_html:     true, # no input tag or textarea
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow' }
      }

      markdown_options = {
        autolink:           true,
        fenced_code_blocks: true,
        lax_spacing:        true,
        no_intra_emphasis:  true,
        strikethrough:      true,
        superscript:        true
      }

      renderer = Redcarpet::Render::HTML.new(html_render_options)
      markdown = Redcarpet::Markdown.new(renderer, markdown_options)
      raw markdown.render(text)
    end

end
