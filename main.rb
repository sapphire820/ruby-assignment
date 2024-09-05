class Account
  class Onboarding
    attr_reader :account, :params

    def initialize(account, params)
      @account = account
      @params = params
    end

    def setup_account!
      return if account.nil?
      return unless params_valid?

      create_preferred_market
      perform_lead_finder_search_later
    end

    private

    def params_valid?
      params[:state].present? && params[:county].present?
    end

    def create_preferred_market
      account.preferred_markets.create!(state: params[:state], county: params[:county])
    end

    def perform_lead_finder_search_later
      self.delay.perform_lead_finder_search
    end

    def perform_lead_finder_search
      %w[vacant tired distant].each do |preset|
        search = build_search(preset)
        build_onboarding_list(search, humanized_search_type(preset))
      end
    end

    def build_search(preset)
      search = Finder::Search.new(type: :lead_finder, account: account, state: params[:state], county: params[:county])
      search.preset = preset
      search
    end

    def build_onboarding_list(search, search_type)
      search.per_page = random_lead_finder_result_count
      search.execute

      return if search.results.count.positive?

      Finder::Property.add_to_campaign!(
        lead_campaigns.create(name: "#{search.county} County #{search.state} - #{search_type} List", intention: 'list', campaign_type: 'lead_finder'),
        ids: search.results.map(&:Finder_id),
        user: users.first,
        track_usage: false
      )
    end

    def humanized_search_type(preset)
      case preset
      when 'vacant'
        'Vacant Houses'
      when 'tired'
        'Tired Landlords'
      when 'distant'
        'Distant Landlords'
      end
    end

    def lead_campaigns
      @lead_campaigns ||= account.lead_campaigns
    end

    def random_lead_finder_result_count
      500 - rand(50)
    end

    def users
      account.users
    end
  end
end
