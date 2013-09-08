module ImportsHelper
  def import_model_options
    list = ['samples','organism']
    options_for_select(list.collect {|d| [ d.humanize, d ] })
  end
end
