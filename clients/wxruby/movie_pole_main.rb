class MoviePoleMain < Wx::Frame
  def initialize
    super
    Wx::XmlResource.get.load_frame_subclass self, nil, "moviepoleframe"

    @feed_list = find_window_by_id Wx::xrcid("feedlist")
    @feed_content = find_window_by_id Wx::xrcid("feed")
    @refresh = find_window_by_id Wx::xrcid("refresh")
    @close = find_window_by_id Wx::xrcid("close")

    evt_button @close.id, :on_close
    evt_button @refresh.id, :on_refresh
    evt_listbox @feed_list.id, :on_feed_list
    evt_html_link_clicked @feed_content.id, :on_feed_content
  end

  def on_close
    close
  end

  def on_refresh
    @refresh.disable
    Thread.new do
      begin
        @feed = FeedNormalizer::FeedNormalizer.parse open("http://apidock.com/notes.rss")
        @feed_list.selection = -1 # due to problems with changing list with selection
        @feed_list.set @feed.entries.map(&:title)
      ensure
        @refresh.enable # ensure that refresh is enabled when something goes wrong
      end
    end
  end

  def on_feed_list
    selected = @feed_list.selections.first
    @feed_content.page = @feed.entries[selected].content
  end

  def on_feed_content(event)
    puts "you clicked on link #{event.get_link_info.get_href}, we'll try to do something with it in the future"
  end
end
