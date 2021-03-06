# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    def index
      page._events_search = []
      # Add code for when the index view is loaded
      page._show_brooklyn = false
      page._show_bronx = false
      page._show_manhattan = false
      page._show_staten_island = false
      page._show_queens = false
      page._show_other = false
    end

    def about
      # Add code for when the about view is loaded
    end

    def get_categories
      EventTasks.get_categories.then do |categories|
        page._categories = categories
      end
    end

    def search_for_events
      boroughs = []
      boroughs << 'Bk' if page._show_brooklyn
      boroughs << 'Bx' if page._show_bronx
      boroughs << 'Mn' if page._show_manhattan
      boroughs << 'SI' if page._show_staten_island
      boroughs << 'Qn' if page._show_queens
      boroughs << 'Ot' if page._show_other
      boroughs_str = boroughs.join('+')

      EventTasks.search_for_events(page._event_category, boroughs_str).then do |events|
        page._events_search = events
      end
    end

    def add_todo
      store._todos << {text: page._new_todo}
      page._new_todo = ''
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
